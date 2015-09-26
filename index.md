---
title       : Movie Title Intuition App
subtitle    : Coursera Developing Data Products Course Project 
author      : Irina Goloshchapova
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
ext_widgets : {rCharts: libraries/nvd3}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Application Background
### Motivation  
- Everyone of us has ever dreamed to be or to feel as a film director.  
- You could take a chance - let's start from the movie idea.  
- Good title could signify sufficient part of success.  
- Or... Well, this is just fun! :-)  

<iframe src="cartoon.jpg" width="350" height="350" scrolling="no" frameBorder="0"></iframe>

---
## About Application (1)
### App Sources  
- [MovieLens 1M Dataset](http://grouplens.org/datasets/movielens/1m/).  
  Stable benchmark dataset. 1 million ratings from 6000 users on 4000 movies. Released 2/2003.  

<div id = 'chart1' class = 'rChart nvd3'></div>
<script type='text/javascript'>
 $(document).ready(function(){
      drawchart1()
    });
    function drawchart1(){  
      var opts = {
 "dom": "chart1",
"width":    700,
"height":    350,
"x": "movieName",
"y": "value",
"group": "genre",
"type": "multiBarHorizontalChart",
"title": "Top-10 Movies in the MovieLens 1M Dataset",
"id": "chart1" 
},
        data = [
 {
 "movieName": "Alaska",
"movieID": 3676,
"genre": "Adventure",
"variable": "rating",
"value":              5 
},
{
 "movieName": "No Small Affair",
"movieID": 1342,
"genre": "Comedy",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Happiness",
"movieID": 1410,
"genre": "Comedy",
"variable": "rating",
"value":              5 
},
{
 "movieName": "King Kong",
"movieID": 1464,
"genre": "Action",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Heartbreak Ridge",
"movieID": 1585,
"genre": "Action",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Ghostbusters",
"movieID": 1852,
"genre": "Comedy",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Stiff Upper Lips",
"movieID": 1909,
"genre": "Comedy",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Bustin' Loose",
"movieID": 2184,
"genre": "Comedy",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Torso",
"movieID": 2714,
"genre": "Horror",
"variable": "rating",
"value":              5 
},
{
 "movieName": "Night of the Creeps",
"movieID": 2939,
"genre": "Comedy",
"variable": "rating",
"value":              5 
} 
]
  
      var data = d3.nest()
        .key(function(d){
          return opts.group === undefined ? 'main' : d[opts.group]
        })
        .entries(data)
      
      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .x(function(d) { return d[opts.x] })
          .y(function(d) { return d[opts.y] })
          .width(opts.width)
          .height(opts.height)
         
        chart
  .showControls(false)
  .margin({
 "left":    110 
})
          
        

        
        
        
        
        
      
       d3.select("#" + opts.id)
        .append('svg')
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
      
      //add our title with html
      //might be better with svg
      d3.select("#" + opts.id).insert("h3","svg")
        .text(opts.title)
        //if desired, could change styling with css or with d3
        //some examples here http://tympanus.net/codrops/2012/11/02/heading-set-styling-with-css/
        //will use example
        //.style("float","right");
        //.style("text-shadow", "0 -1px 1px rgba(0,0,0,0.4)")
        .style("font-size","22px")
        .style("line-height", "40px")
        .style("color", "#355681")
        //.style("ext-transform", "uppercase")
        .style("border-bottom", "1px solid rgba(53,86,129, 0.3)");
    };
</script>

---
## About Application (2)
### Calculations
1. We take all movies titles, their genre categories and average ratings from all users.  
2. Then, we perform basic text mining analysis (`package 'tm'`) for the most frequent words in 4000 movies titles.  
3. At this step we train simple `glm` model to predict average rating (on a scale from 1 to 5) by frequent words dataset and the movie genre.
4. And that's it. You could try the new shinyapp [here](https://irinagoloshchapova.shinyapps.io/MovieTitleIntuition). 
   And look at the full code [here](https://github.com/IrinaGoloshchapova/DevDataProd). 

---
## About Application (3)
### How to use
1. Come up with the best title for your New Great Movie and enter it into the "Title" box. By default, we assume that your movie title is "Third Zombie Train". I think that it would be a great movie! And what about you?  
2. Choose a genre for your New Great Movie in "Genre" box.
3. Push the button "Update Your Movie Rating Forecast" and look at the forecast of the average rating of your movie on a scale from 1 to 5.  
   **NOTE:** *Please, be patient!* The app initialization (first-order calculations) could take 3-4 minutes. Then, from the second title input it works really fast. Enjoy!

