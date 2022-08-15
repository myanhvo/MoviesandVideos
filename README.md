# Movies and Videos

<br>

$$\textbf{ \huge Movies Recommendation Using Specified Genre}$$

<br>

$\textbf{ \large I. Introduction}$

In the busy modern life, everyone wants to escape the stressful working or studying environment. What could be a better solution than staying at home in pajamas and having an amazing movie night? There are a variety of movies to choose from, and it has to fit our current mood perfectly. When someone feels like they need a fun break, comedy would be a go-to. Or when someone wants to still feel productive, how about watching a scientific documentary? The movie industry has improved a lot, therefore many movies with different genres all together are produced. However, people do have different preferences on what they want to watch. This is where the program will comes in helpful.

This SAS program allows users to specify a genre, and they will be given some information regarding what the best fits for them are. The users will have a variety of choice, from number of movies they want recommendations on, to the relevant information about that specific movies. They can also specify if they want new movies or classic ones, and whether or not they want to depend on the public ratings to choose their dream movie.

$\textbf{ \large II. Datasets Preparation}$

$\textbf{1. Original task assigned}$

The file genome-scores.csv contains tag relevance scores for different movies. For each movie, select the tags that correspond to the highest 5 relevance scores and then summarize them in a few keywords. Link these summarized keywords with the ratings the movie gets. Write a SAS macro so that when the user specifies a genre, your program generates graphs/tables that show the most popular keywords (you may use the average rating or other measures that make sense) and a few suggested movies for that genre).

$\textbf{2. Description of Dataset}$

README file of the dataset, provided by the University of Minnesota:

https://files.grouplens.org/datasets/movielens/ml-latest-README.html

> This dataset (ml-latest) describes 5-star rating and free-text tagging activity from MovieLens, a movie recommendation service. It contains 27753444 ratings and 1108997 tag applications across 58098 movies. These data were created by 283228 users between January 09, 1995 and September 26, 2018. This dataset was generated on September 26, 2018. Users were selected at random for inclusion. All selected users had rated at least 1 movies. No demographic information is included. Each user is represented by an id, and no other information is provided.

Six datasets in csv format were given with the following names: genome-scores.csv, genome-tags.csv, tags.csv, movies.csv, links.csv, and ratings.csv. There are a lot of missing information in these datasets, so I have advanced to remove some *when needed*.

The following table provided all inputs from all files, which accounts for credibility in analysis. All files were used, except for links. There is not enough information provided by this links.csv dataset, and not much were needed there for analysis. There are several new datasets that would be created directly in the program, and will be indicated later.

| CSV Files\ Vars | movieId | tagId | tag | title | genre | imdbId | tmdId | userId | timestamp | relevance | ratings |
|---|---|---|---|---|---|---|---|---|---|---|---|
| genome_scores | x | x |  |  |  |  |  |  |  |  |  |
| genome_tags |  | x | x |  |  |  |  |  |  | x |  |
| tags | x |  | x |  |  |  |  | x | x |  |  |
| links | x |  |  |  |  | x | x |  |  |  |  |
| movies | x |  |  | x | x |  |  |  |  |  |  |
| ratings | x |  |  |  |  |  |  | x | x |  | x |

**Table 1: CSV files and variables contained in the files for analyzing purposes.**

<br>

**Variables appendix:**

Additionally, users can review the detailed description of variables used across six datasets in the appendix below

```
movieId         : the ID given to the movie

tagId           : the ID given to the tags
 
tags            : the names of the tags, basically keywords to describe the movies
  
title           : movie titles

genre           : genre of the movies. One movie can fall to many different genres

ImdbId/tmbID    : Id of IMDB scores and TMB

userId          : ID of users that gave ratings to the movies

timestamp       : timestamp of recorded ratings

relevance       : relevance scores of the movies

ratings         : ratings given by users
```

$\textbf{ \large III. Report}$

$\textbf{ 1. Project Description}$

This program was finished as of May 11th, 2022. It accepts a user specified genre, gives them a user-specified number of tags/keywords that are relevant to the genres, and a user specified number of movies relevant to the genre and keywords. It was improved to accept if the user wants the newest movies related to their genres, or the oldest movies related to their genres, or the new/old movies that has highest ratings from their peer movie watchers. The users can choose to look at the data by tables or visuals by indicating in the macro.$

$\textbf{ 2. Visuals Description}$

$\textbf{ A. First step in getting tags for movies}$

<p align="center">
  <img width="771" alt="Screen Shot 2022-08-15 at 02 40 40" src="https://user-images.githubusercontent.com/84951426/184588802-960324ae-4641-4c75-8ef3-c251d6cc939b.png">
</p>

**Table 2: Tags sorted by relevance scores of movie with ID = 1**

Here, with all datasets already merged and in place, the table above shows the different tags applying to a movieID, and these tags are sorted by relevance scores. This datasets has exactly 1128 tags, and there are different tags associated with the movies based on the relevance scores. We can see this applies to the movie with ID = 2 as well through the tables below:

<p align="center">
  <img width="713" alt="Screen Shot 2022-08-15 at 03 30 40" src="https://user-images.githubusercontent.com/84951426/184594293-1e5f8cf8-b3af-43d7-9cdf-de6c0667a28c.png">
</p>

**Table 3: Tags sorted by relevance scores of movie with ID = 2**


$\textbf{B. Average ratings of movies based on movies ID}$

<p align="center">
  <img width="876" alt="Screen Shot 2022-08-15 at 03 32 42" src="https://user-images.githubusercontent.com/84951426/184594417-eefc8237-3ca1-4699-a62a-17d1e7b0fbaf.png">
</p>


**Figure 1 : Bar plot of general mean ratings dataset, showing the first 20 ratings**

This plot was created with the purpose of comparing mean ratings given by different users between movies. Here, the user specified the movies with ID starting from 1, and they want to know 20 next movies. We can also see a wider range than this, which should be easy just by specifying it in the macro in the program. This is a very general plot, as it was not specified by anything or sorted by anything, except for the movie ID. It just generally shows the trend of ratings within a movie, and it gives the audience a general idea on what to expect in the next part of the report. The line plot method was also used, but visually it is inefficient than the bar plot. An example would be below:

<p align="center">
  <img width="899" alt="Screen Shot 2022-08-15 at 03 33 50" src="https://user-images.githubusercontent.com/84951426/184594593-53b5f2a0-e065-4725-8a92-076c37761e96.png">
</p>

**Figure 2: Line plot of general mean ratings dataset, showing the first 20 ratings**

As we can see, somehow this graph seems misleading due to the very different unit measures of the average score in the left side. Although average scores aren’t really that different from each other, the fluctuations in the graph makes it seem like they differ a lot. Therefore, bar plots should be our best choice.

$\textbf{C. Suggesting movies based on user-specified genres}$

This is the main part of the program. The macro named program was created, and it has 7 input parameters: `in`, `out`, `genre`, `numTags`, `numMovies`, `sortby`, `print`

This macro already has a default in file and out file, but for potential later usage, it was added as a parameter for the macro. 

Here is the main function of the program. The users will specify a genre that they want using `genre = `, WITHIN THIS LIST provided by the dataset: **Action, Adventure, Animation, Children's, Comedy, Crime, Documentary, Drama, Fantasy, Film-Noir, Horror, Musical, Mystery, Romance, Sci-Fi, Thriller, War, Western, (no genres listed)**. They have an option to specify the number of tags they want to see using `numTags = `, in relevance with the movie. They can also specify the number of movies they want recommended using `numMovies =`. Next, they can use `sortby = `, and they will have these _FIVE_ options: 

```
0  : sort movies by descending average ratings 
1  : sort movies by newest movies to oldest, regardless of ratings 
2  : sort movies by oldest movies to newest, regardless of ratings 
3  : sort movies by newest to oldest movies AND descending average ratings 
4  : sort movies by oldest to newest movies AND descending average ratings
```

After that, they can choose whether or not the purpose of their visiting the macro is looking at the table or using the macro for visualization. This is going to be explained further in the upcoming parts.

Some defaults numbers are initially chosen. I have specified the macro to show *FIVE* tags for every genre, as well as *TEN* movies, sorting the data by descending average ratings (`sortby = 0`), and choose `print = 0` to show the tables instead of the visualization.

Below are some outputs generated:

``` %program(genre = "Action", numTags = 3, numMovies = 5, sortby=0);```

<p align="center">
  <img width="701" alt="Screen Shot 2022-08-15 at 03 45 54" src="https://user-images.githubusercontent.com/84951426/184596235-bc387ce7-39e9-4203-8176-00b50e08372f.png">
</p>

**Table 4: Top 5 Action movies with 3 tags – sort from highest ratings to lowest**

 <br>
 
```%program(genre = "Comedy", numTags = 5, numMovies = 10, sortby=1);```

<p align="center">
  <img width="688" alt="Screen Shot 2022-08-15 at 03 46 24" src="https://user-images.githubusercontent.com/84951426/184596292-be974530-faf0-420f-b14f-e9764f227319.png">
</p>

**Table 5: Top 10 Comedy movies with 5 tags – sort from newest movies to oldest movies**

 <br>
 
```%program(genre = "Horror", numTags = 5, numMovies = 10, sortby=2);```

<p align="center">
  <img width="699" alt="Screen Shot 2022-08-15 at 03 46 46" src="https://user-images.githubusercontent.com/84951426/184596337-75c579e2-9ce3-40a4-81f3-5b588f5f519e.png">
</p>

**Table 6: Top 10 Horror movies with 5 tags – sort from oldest movies to newest movies**

<br>
 
```Calling %program(genre = "Musical", numTags = 3, numMovies = 20, sortby=3);```

<p align="center">
  <img width="700" alt="Screen Shot 2022-08-15 at 03 47 06" src="https://user-images.githubusercontent.com/84951426/184596386-c3cb1dc9-6934-430c-bd7d-e4bbb45a424c.png">
</p>

**Table 7: Top 10 Musical movies with 3 tags – sort newest movies to oldest movies, by highest ratings**

<br>


```Calling %program(genre = "Sci-Fi", numTags = 2, numMovies = 5, sortby=4);```

<p align="center">
  <img width="629" alt="Screen Shot 2022-08-15 at 03 47 19" src="https://user-images.githubusercontent.com/84951426/184596415-4d37d4c4-adca-4389-b923-7df70dd7bcb0.png">
</p>

**Table 8: Top 5 Sci-Fi movies with 5 tags – sort from oldest movies to newest movies, by highest ratings**


...Updating...

