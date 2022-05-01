/*Progress Update
This program is used for the Term Project, performing
tasks asked.*/

/*The following 6 import statements import all 6
datasets: genome_scores, genome_tags, tags, 
movies, links, ratings.
It takes in the path for datafile and specify 
the type as CSV files*/
proc import
	datafile= "M:\sta402\TermProject\genome-scores.csv" /* this is the CSV
	                                    file we want to read */
	out = genome_scores /* this is a new SAS data set */
	dbms=csv      /* tell SAS this really is a CSV file */
	replace;      /* tell SAS to overwrite any existing
	             SAS data set called genome_scores*/
run;

proc import
	datafile= "M:\sta402\TermProject\genome-tags.csv" 
	out = genome_tags 
	dbms=csv      
	replace;     
run;

proc import
	datafile= "M:\sta402\TermProject\movies.csv" 
	out = movies 
	dbms=csv      
	replace;    
run;

proc import
	datafile= "M:\sta402\TermProject\links.csv"
	out = links 
	dbms=csv    
	replace;      
run;

proc import
	datafile= "M:\sta402\TermProject\tags.csv" 
	out = tags
	dbms=csv    
	replace;    
run;

proc import
	datafile= "M:\sta402\TermProject\ratings.csv" 
	out = ratings 
	dbms=csv    
	replace;     
run;

/*Sort the genome scores dataset by tagId*/
proc sort data = genome_scores out = genome_scores_sortted;
	by tagId;

/*Merge the new sorted genome scores with genome tags
New dataset is called tags_merged*/
data tags_merged;
	merge genome_scores_sortted genome_tags;
	by tagId;
run;

/*Sort the tags_merged dataset by movieID and descending
relevance score*/
proc sort data = tags_merged out = tags_merged_sortted;
	by movieID descending relevance;

ods rtf bodytitle file =  "M:\sta402\TermProject\Tester.rtf";
/*Print out the first 10 observations*/
title "Tags sorted by relevance scores";
proc print data =  tags_merged_sortted(obs = 10);
run; 
ods rtf close;


/*This data step transpose the tags_merged_sortted
dataset and get the 5 tags with highest relevance
score*/
data getTags;
	do k=1 to 187595;
		array C{1128} $;         /*array of characters*/
		do i=1 to 1128;
			set tags_merged_sortted;
			C{i} = tag;

		end;
		output;
	end;
	drop C6-C1128;               /*Top 5, we don't need 
	                             6 to 1128*/
	drop i k tag tagId relevance;
run;

/*This datastep remove the NAs variables within the 
getTags dataset*/
data no_nas;
	set getTags;
	if cmiss(of C1-C5) then delete;
run;

/*This data step sort the ratings dataset
by movieId*/
proc sort data = ratings out = ratings_sortted;
	by movieID;

/*This data step compute the average ratings group by
movieIDs*/
proc means data=ratings_sortted noprint;
	class movieId;
	var rating;
	output out = mean_ratings mean = Avg;
run;

/*This data step filter the mean_ratings dataset,
remove unrelated variables*/
data meanRatings;
	set mean_ratings;
	where movieId > 0;
	drop _TYPE_ _FREQ_;
run;

/*This macro create a user specified range 
of mean ratings of movies for user to see*/
%macro rating_graphs(numMovies=, start=1);
	proc sgplot data=meanRatings(firstobs = &start obs = &numMovies);
		vbar movieId / response = Avg; 
		yaxis label = "Average ratings score out of 5";
		xaxis label = "Movies Id";
	run;
%mend rating_graphs;

ods rtf bodytitle file =  "M:\sta402\TermProject\Tester2.rtf";
title "Bar plot of meanRatings dataset";
%rating_graphs(numMovies= 20, start=1);
ods rtf close;


/*This dataset merge the getTags dataset and meanRatings
to link tags to ratings by movieId*/
data ratings_merged;
	merge getTags meanRatings;
	by movieId;
run;

/*This dataset merge the movies dataset to the 
ratings_merged dataset by movieId*/
data genres_merged;
	merge movies ratings_merged ;
	by movieId;
run;

ods rtf bodytitle file =  "M:\sta402\TermProject\Tester3.rtf";
/*Print out the first 20 observations of the final file*/
title "Final files for building macros";

proc print data = genres_merged(obs = 20);
run; 
ods rtf close;
