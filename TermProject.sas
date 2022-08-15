
/*
Anh Vo
Final Project Submission
05/11/2022

Final program, completed all the tasks assigned. Original
task statement is as follows:

The file genome-scores.csv contains tag relevance scores for different 
movies. For each movie, select the tags that correspond to the highest 
5 relevance scores and then summarize them in a few keywords. Link these
summarized keywords with the ratings the movie gets. Write a SAS macro
so that when the user specifies a genre, your program generates 
graphs/tables that show the most popular keywords (you may use the 
average rating or other measures that make sense) and a few suggested 
movies for that genre). 

*/



/*Users can specify the folder here by changing the %let statement,
then run this whole program.*/
%let path = M:\sta402\TermProject;


/*The following 6 import statements import all 6
datasets: genome_scores, genome_tags, tags, 
movies, links, ratings.
It takes in the path for datafile and specify 
the type as CSV files*/

%macro importFiles(in =, out=);

	proc import
	datafile= &in /* this is the CSV
	                                    file we want to read */
	out = &out /* this is a new SAS data set */
	dbms=csv      /* tell SAS this really is a CSV file */
	replace;      /* tell SAS to overwrite any existing
	             SAS data set called genome_scores*/
run;

%mend importFiles;


%importFiles(in =  "&path\genome-scores.csv", out = genome_scores);
%importFiles(in =  "&path\genome-tags.csv", out = genome_tags);
%importFiles(in =  "&path\movies.csv", out = movies);
%importFiles(in =  "&path\ratings.csv", out = ratings);
%importFiles(in =  "&path\links.csv", out = links);
%importFiles(in =  "&path\tags.csv", out = tags);


/*PART I:
The following part merges all needed data into a file called no_nas. 
It will perform tags merging with movies ID, and tags transpose to
show a later specified number of tags for the users 
*/



/*Sort the genome scores dataset by tagId
Function: To easily merge it with the genome_tags file*/
proc sort data = genome_scores out = genome_scores_sortted;
	by tagId;
run;

/*Merge the new sorted genome scores with genome tags
New dataset is called tags_merged
Function: To get relevance scores for each tag ID*/
data tags_merged;
	merge genome_scores_sortted genome_tags;
	by tagId;
run;

/*Sort the tags_merged dataset by movieID and descending
relevance score
Function: To list by movies. Get all 1128 tags for each movie,
each tags sorted by relevance score*/
proc sort data = tags_merged out = tags_merged_sortted;
	by movieID descending relevance;
run;

ods rtf bodytitle file =  "&path\AllTags_sorted.rtf";
/*Print out the first 10 observations of movie with ID = 2*/
title "Tags sorted by relevance scores";
proc print data =  tags_merged_sortted(firstobs = 1129 obs = 1139);
run; 
ods rtf close;


/*This data step transpose the tags_merged_sortted
dataset and get the all tags scores
*/

data getTags;                    
	do k=1 to 187595;			/*data length after removed irrelevant
								- NAs*/
		array C{1128} $;         /*array of characters*/
		do i=1 to 1128;
			set tags_merged_sortted;
			C{i} = tag;

		end;
		output;
	end;
	    
	drop i k tag tagId relevance;
run;

/*This datastep remove the NAs variables within the 
getTags dataset*/
data no_nas;
	set getTags;
	if cmiss(of C1-C1128) then delete;
run;



/*PART II:
The following part works on another part in cleaning data
to prepare for the big macro*/



/*This data step sorts the ratings dataset
by movieId
Function: To later compute the means across MovieIDs
*/
proc sort data = ratings out = ratings_sortted;
	by movieID;
run;

/*This data step computes the average ratings group by
movieIDs
Function: Compute the means to later show to users, as
they want movies with high ratings
*/
proc means data=ratings_sortted noprint;
	class movieId;
	var rating;
	output out = mean_ratings mean = Avg;
run;

/*This data step filters the mean_ratings dataset,
remove unrelated variables
Function: Clean data
*/
data meanRatings;
	set mean_ratings;
	where movieId > 0;
	drop _TYPE_ _FREQ_;
run;

/*This macro create a user specified range 
of mean ratings of movies for user to see
Function: Create a graph that shows average ratings
across a specific movieId.
*/
%macro rating_graphs(numMovies=, start=1);
	proc sgplot data=meanRatings(firstobs = &start obs = &numMovies);
		vbar movieId / response = Avg; 
		yaxis label = "Average ratings score out of 5";
		xaxis label = "Movies Id";
	run;
%mend rating_graphs;

ods rtf bodytitle file =  "&path\ratings_plot.rtf";
title "Bar plot of meanRatings dataset";
%rating_graphs(numMovies= 20, start=1);
ods rtf close;




/*PART III:
The following part starts merging data from Part I and Part II
to prepare for the big macro*/




/*This datastep merge the getTags dataset and meanRatings
to link tags to ratings by movieId*/
data ratings_merged;
	merge no_nas meanRatings;
	by movieId;
run;

/*This datastep merge the movies dataset to the 
ratings_merged dataset by movieId*/
data genres_merged;
	merge movies ratings_merged;
	by movieId;
run;

/*This data step sort the average ratings from 
highest to lowest*/
proc sort data = genres_merged out = genres_merged_sorted;
	by descending Avg;
run;
 
/*This data step removes NAs from the sorted average ratings 
computed above */
data genres_nonas;
	set genres_merged_sorted;
	if cmiss(of C1-C1128) then delete;
run;


/*Part IV: The big macro*/

/*This macro gets a user-specified genre, then suggest a user-specified
number of movies for the users. It also gets a user-specified number
of keywords related to the movies
	Input: in         = the infile that will do the macro, 
						default = genres_nonas unless indicated otherwise,
		   out        = the output file, usually don't need it unless 
						using for visualization macro below
						default = temp unless indicated otherwise
		   genre      = the genre of the movies
						no default, needs to specify from list
		   numTags    = the number of keywords
						default = 5 unless indicated otherwise
		   numMovies  = the number of movies for suggestions
						default = 10 unless indicated otherwise
		   sortby     = indicator for 5 different scenarios, as follows:
						default = 0 unless indicated otherwise
		0: sort movies by descending average ratings
		1: sort movies by newest movies to oldest, regardless of ratings
		2: sort movies by oldest movies to newest, regardless of ratings
		3: sort movies by newest to oldest movies AND descending average ratings
		4: sort movies by oldest to newest movies AND descending average ratings

		   print      = decide if users want the tables to be printed. 
						usually no printing needed for visualization
						default = 1 unless indicated otherwise
		0: no print
		1: print

*/

%macro program(in = genres_nonas, out = temp, genre =, numTags =5, numMovies=10, sortby=0, print=1);
%let num = %eval(&numTags+1);      *sets where to start removing tags;

/*
Gets the file and starts finding the specified genre in the
genre string. Then it performed extensive cleaning to get
the release year for later usage.
Note: Year released could be NA.
*/
data pre;
	set &in;
		i = find(genres, &genre, "i");
		temp = substr(title, length(title)-4,4); *last 4;
		Year = compress(temp, ' ', 'kd');  *remove spaces;
run;

/*
Use for programs that needs the year
The year must be known, so no NAs and 
no invalid years
*/
data tempdata;
	set pre;

	/*Known that years ranged from ~1900 to 2018
	but a wider range to increase inclusive*/
	if 1900 <= Year <= 2022 then output;
run;


/*
IF-ELSE part. It takes the sortby information specified by
the users, and perform in accordance to their interest
*/

*sorts by descending average ratings;
%IF &sortby = 0  %THEN %DO;
proc sort data = pre out = pre_new;
	by descending Avg;
run;
%END;

*sorts by descending year released;
%IF &sortby= 1  %THEN %DO;
proc sort data = pre out = pre_new;
	by descending Year;
run;
%END;

*sorts by ascending year released;
%IF &sortby = 2  %THEN %DO;
proc sort data = tempdata out = pre_new;
	by Year;
run;
%END;

/*sorts by newest years released AND descending
average ratings*/
%IF &sortby = 3  %THEN %DO;
proc sort data = pre out = pre_new;
	by descending Year descending Avg ;
run;
%END;

/*sorts by oldest years released AND descending
average ratings*/
%IF &sortby = 4  %THEN %DO;
proc sort data = tempdata out = pre_new;
	by Year descending Avg ;
run;
%END;

/*
Final data. It cleans up the program for a better output.
It sets a user-specified number of movies, then decide
if the genre is in the data (i.e. i not equals 0). 
It also round ratings by 2 decimal places for displaying
purposes. It then rename tags (C1- to Tag1-). Finally,
it reorder the columns for displaying purposes.
*/
data &out;
	set pre_new(obs = &numMovies);
	where i ne 0;
	Ratings = round(Avg, 0.01);
	drop C&num-C1128 i movieId temp Avg;
	rename C1-C&numTags=Tag1-Tag&numTags;
	retain title genre Tag1-Tag&numTags Year Ratings;
run;

/*
Indicating whether or not tables should be printed
*/
%IF &print = 1 %THEN %DO;
proc print data = &out;
run;
%END;


%mend program;


/* 
Example runs for each cases
*/

ods rtf bodytitle file =  "&path\Movie_Suggestions.rtf";
/*Print out the first 10 observations of the final_year file*/
title "Top 5 Action movies with 3 tags - by ratings";
%program(genre = "Action", numTags = 3, numMovies = 5, sortby=0);

title "Top 10 Comedy movies with 5 tags - by newest release year";
%program(genre = "Comedy", numTags = 5, numMovies = 10, sortby=1);

title "Top 10 Horror movies with 5 tags - by oldest release year";
%program(genre = "Horror", numTags = 5, numMovies = 10, sortby=2);

title "Top 20 Musical movies with 3 tags - by newest and high ratings";
%program(genre = "Musical", numTags = 3, numMovies = 20, sortby=3);

title "Top 5 Sci-Fi movies with 2 tags - by oldest and high ratings";
%program(genre = "Sci-Fi", numTags = 2, numMovies = 5, sortby=4);

ods rtf close;


/*
This macro create a user specified range 
of mean ratings of movies in the specified genre for user to see

Input: 
		numMovies  = number of movies that the users specify
					 default = 10 unless indicated otherwise
		start      = the index of movie within the genre 
					 default = 1 unless indicated otherwise
		genre      = the genre specified by the user
					 no default, need to be specified

Note: Start > 58098 cannot be specified. This is the maximum 
number of movies in the dataset.

*/
%macro genres_scores(numMovies=10, start=1, genre=);
	%let endnum = %eval(&numMovies+&start); *get where to end;

	/*
	Calling three program macros to get the output file
	numMovies may be less than 58098, but it's the total
	and should all be accumulated so the users can specify
	the ith number of movie and range.
	*/
	%program(in = genres_nonas, out = file, genre = &genre,
			numMovies = 58098, print=0);
	%program(in = genres_nonas, out = file2, genre = &genre, 
			numMovies = 58098, sortby = 3, print=0);
	%program(in = genres_nonas, out = file3, genre = &genre, 
			numMovies = 58098, sortby = 4, print=0);

	/*
	Bar plot showing general average ratings of a movie 
	within a genre
	*/
	proc sgplot data=file(firstobs = &start obs = &endnum);
		vbar title / response = Ratings; 
		yaxis label = "Average ratings score out of 5";
		xaxis label = "Movies";
	run;

	/*
	Bar plot showing average ratings of a movie within a genre, 
	listing from newest movies to oldest movies
	*/
	proc sgplot data=file2(firstobs = &start obs = &endnum);
		vbar title / response = Ratings; 
		yaxis label = "Average ratings score out of 5";
		xaxis label = "Movies newest to oldest";
	run;

		/*
	Bar plot showing average ratings of a movie within a genre, 
	listing from oldest movies to newest movies
	*/
	proc sgplot data=file3(firstobs = &start obs = &endnum);
		vbar title / response = Ratings; 
		yaxis label = "Average ratings score out of 5";
		xaxis label = "Movies oldest to newest";
	run;

%mend rating_graphs;


/*
Example runs for two genres. Only Action shown in report.
Testing Comedy to see if it can starts at the 20th movie
and it worked
*/
ods rtf bodytitle file =  "&path\Suggestions_plots.rtf";
title "Bar plot for Action genre";
%genres_scores(numMovies= 10, start=1, genre = "Action");

title "Bar plot for Comedy genre, starts at the 20th movie";
%genres_scores(numMovies= 10, start=20, genre = "Comedy");
ods rtf close;

