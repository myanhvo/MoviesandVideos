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

[ml-latest-README.html](https://files.grouplens.org/datasets/movielens/ml-latest-README.html)

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

<br> 

$\textbf{\large Genre: Action}$

``` %program(genre = "Action", numTags = 3, numMovies = 5, sortby=0);```

<p align="center">
  <img width="701" alt="Screen Shot 2022-08-15 at 03 45 54" src="https://user-images.githubusercontent.com/84951426/184596235-bc387ce7-39e9-4203-8176-00b50e08372f.png">
</p>

**Table 4: Top 5 Action movies with 3 tags – sort from highest ratings to lowest**

<br>

$\textbf{\large Genre: Comedy}$

```%program(genre = "Comedy", numTags = 5, numMovies = 10, sortby=1);```

<p align="center">
  <img width="688" alt="Screen Shot 2022-08-15 at 03 46 24" src="https://user-images.githubusercontent.com/84951426/184596292-be974530-faf0-420f-b14f-e9764f227319.png">
</p>

**Table 5: Top 10 Comedy movies with 5 tags – sort from newest movies to oldest movies**

 <br>
 
 $\textbf{\large Genre: Horror}$
 
```%program(genre = "Horror", numTags = 5, numMovies = 10, sortby=2);```

<p align="center">
  <img width="699" alt="Screen Shot 2022-08-15 at 03 46 46" src="https://user-images.githubusercontent.com/84951426/184596337-75c579e2-9ce3-40a4-81f3-5b588f5f519e.png">
</p>

**Table 6: Top 10 Horror movies with 5 tags – sort from oldest movies to newest movies**

<br>

 $\textbf{\large Genre: Musical}$
 
```Calling %program(genre = "Musical", numTags = 3, numMovies = 20, sortby=3);```

<p align="center">
  <img width="700" alt="Screen Shot 2022-08-15 at 03 47 06" src="https://user-images.githubusercontent.com/84951426/184596386-c3cb1dc9-6934-430c-bd7d-e4bbb45a424c.png">
</p>

**Table 7: Top 10 Musical movies with 3 tags – sort newest movies to oldest movies, by highest ratings**

<br>


$\textbf{\large Genre: Sci-Fi}$

```Calling %program(genre = "Sci-Fi", numTags = 2, numMovies = 5, sortby=4);```


<p align="center">
  <img width="629" alt="Screen Shot 2022-08-15 at 03 47 19" src="https://user-images.githubusercontent.com/84951426/184596415-4d37d4c4-adca-4389-b923-7df70dd7bcb0.png">
</p>

**Table 8: Top 5 Sci-Fi movies with 5 tags – sort from oldest movies to newest movies, by highest ratings**

<br>

**D. Visualize suggested movies based on user-specified settings**

As mentioned before, the print= option in macro is useful in this scenario. I have created another macro called genres_scores, and this macro has the following input parameters: `numMovies`, `start`, `genre`

To further explain it, this macro created several bar plots based on the genre specified. The user will automatically receive three different bar plots: one with the general ratings for a specified range of movies (`numMovies =`), one with the highest to lowest ratings of newest to oldest movies, and one with the highest to lowest ratings of oldest to newest movies. The user can specify the where they want to look at within the data, or specifically, they can look at the 20<sup>th</sup> or 50<sup>th</sup> movie within that genre of interest. Using `start =` will help them identify the index of movies that they want to look at.

This macro makes use of the information from the previous macro, which has a print statement default in it, so `print =` will specify whether or not the user wants the table to be printed again when they look at the bar plots. The parameter `print = 0` will not print the tables, while `print = 1` does.
One note that should be useful: Users _CANNOT_ specify the start that is more than 58090, since that the maximum number of movies in _TOTAL_, not for each genre.

Below are the example bar plots for the Action genre, sorted:

**Note: This function automatically creates 3 bar plots: 1 General, 1 sorted from newest to oldest, and vice versa.

<br>

```Calling %genres_scores(numMovies= 10, start=1, genre = "Action");```

<p align="center">
  <img width="586" alt="Screen Shot 2022-08-15 at 13 31 38" src="https://user-images.githubusercontent.com/84951426/184685662-e9718340-a9ef-42af-8b75-e41a36950e41.png">
</p>

**Figure 3: Bar plots of general ratings of different movies for Action genre**

<p align="center">
  <img width="718" alt="Screen Shot 2022-08-15 at 12 56 43" src="https://user-images.githubusercontent.com/84951426/184680152-c90bbe6d-8ea6-489f-8b75-5fc76e268b5d.png">
</p>

**Figure 4: Bar plots of ratings of different movies for Action genre, from newest movies to oldest**

<p align="center">
  <img width="716" alt="Screen Shot 2022-08-15 at 12 56 55" src="https://user-images.githubusercontent.com/84951426/184680186-781985ea-50b3-47bc-bc74-5c81606063e1.png">
</p>

**Figure 5: Bar plots of ratings of different movies for Action genre, from oldest movies to newest**

<br>

$\textbf{ \large IV. About the displays}$

Above, I have made comments regarding the visualizations of tables and plots. They are very useful data for the users to consider when selecting a movie based on genre. The genre is a very broad term to use, so it is also a useful tool to look at. Some of the tags mentioned: “wwi,” “greed,” “classic,” “amazing,” etc, so the users can look at this and determine whether or not they want to watch those movies.

I explained the first two tables regarding sorting very clearly above. These tables are just a pre review for all process that will be done later. They are just to see the correctness of my code. The next two plots provide data visualization for average rating scores across movies ID. I showed two different method of displaying – one with bar plot and one with line plot. I discovered that the line plot created a misunderstanding in data analysis, so I proceed with the bar plot.

To further explain my last tables, you can take a look at them above. I displayed five different scenarios where the users can specify the macros. Movie names are suggested first, and genres follow. Notice that the movies are not purely of one genres – some are crime + comedy, or some are war + comedy. These are two very different genres, so this is where the usefulness of the tags comes in. Because the movies are still under that specific genre, it would still be listed in the table. There are hardly any movies in the dataset that is a pure genre, so this is why I have to list them all. Also, the genre has to be one listed Section II Part C. Then, the tags are listed as different columns for easiness in visualization. Next to the tags are the release year of the movies, taken directly from the movie names. Some of the movie names failed to have the release year there, resulting in missing years. Those movies with missing years are not listed if the users want movie suggestions by year. The last column is the average ratings score by the users. These are very trust-worthy, as they are rated by the randomly chosen users, and there are a huge amount of ratings that I used to compute these averages. I have sorted them from highest to lowest, so that the users can see the movies that is most worthy to be watched based on the genre that they like. Those who preferred to see release years, however, will also get the option of both release year and ratings, if specified as instructed.

$\textbf{ \large V. Conclusion}$

This program is made to be user-friendly, although it still needs to be updated a lot. Through this program, the user can specify everything that they like, from a wide range of genres and tags related, without going to Google and looking at the data themselves. Apart from that, they can get a good look at the ratings trend for many different movies of that genre, if they prefer too! Just by a single line of code, users can enjoy a lovely Sunday with themselves or their families, with a variety of suggestions of movies. If anyone feels like 2018 – modern and technologically, then specify a range of newest movies. Or if they feel like reminiscing the past – movies from 1926 are waiting.

This program was built with the intention to help users get to their favorite movie selection as fast as possible – with the hope that enough information is display for users to consider. I hope that many users will find it helpful.

