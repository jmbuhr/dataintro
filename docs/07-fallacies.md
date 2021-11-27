# Fallacies, Correlation and Regression

> ... in which we hear Stories of Warplanes,
  Correlation and Regression and explore the Datasaurus Dozen.
  
::: {.video-container}
<iframe class="video" src="https://www.youtube.com/embed/vX1WGlFNtBo?vq=hd1080" allowfullscreen></iframe>
:::

## Setup


```r
library(tidyverse)
library(glue)
library(broom)
```

## Data Considerations

### 1943

It is 1943. The second World War is well underway, ravaging large parts of Europe.
Military aircraft that had first entered the stage in World War I are now
reaching their peak importance as they rain fire from the skies. But the Allied
forces are facing a problem. As warplanes get better, so do anti-aircraft
systems. In an effort to improve the survival of their fleet, the US military
starts examining the planes returning from skirmishes with the opposing forces.
They characterize the pattern of bullet holes in the metal hull, meticulously
noting down each hit that the plane sustained. The resulting picture is better
summarized in the modern, redrawn version below.

![Figure from Wikipedia @SurvivorshipBias2020.](images/survivorship-bias.png)

After taking a look at the data they gathered, the military is ready to rush
into action. To improve the endurance of their aircraft, the plan is to
reinforce the parts of the plane that were most often hit by bullets. With
stronger wings and a sturdier body of the plane, they think, surely more pilots
will come back from their missions safely. They were wrong.

But the pilots where in luck. The military also consulted with the Statistics
Research Group at Columbia University. A man named Abraham Wald worked there. In
his now unclassified report "A method of estimating plane vulnerability based on
damage of survivors", he argued against the generals' conclusion
[@waldReprintMethodEstimating1980]. Instead of the most-hit parts of the planes,
the least-hit parts are to be reinforced.

![Cover of "A method of estimating plane vulnerability based on damage of survivors" @waldReprintMethodEstimating1980](images/paste-57122EF0.png)

> Instead of the most-hit parts, the least-hit parts are to be reinforced.

The reason for this seemingly counterintuitive result is what is now known as
*survivorship bias*. The data that was collected contained only survivors, those
planes that sustained damage not severe enough to hinder them from coming back
after their mission. The aircraft that where hit in other places simply didn't
make it back. Consequently, Wald advised to reinforce the engines and the fuel
tanks.

### Thinking further

This is but one of a multitude of biases, specifically a selection bias, that
will influence the quality of the inferences you can draw from available data.
Keep in mind, data is not objective and never exists in a vacuum. There is
always context to consider. The way the data was collected is just one of them.
A lot of these ideas seem obvious in hindsight, which incidentally is another
bias that social psychologists call *hindsight bias*, but they can sometimes be
hard to spot.

A common saying is that music was better back in the days, or that all the old
music still holds up while the new stuff on the radio just sounds the same.
Well, not quite. This is also survivorship bias at work. All the bad and
forgettable songs from the past just faded into oblivion, never to be mentioned
again, while the songs people generally agreed to be good survived the ravages
of time unscathed.
A similar thing happens with success in general, not just songs.
If you ask any CEO high up the corporate ladder, a millionaire, or the author of a
book that reads "How to get rich", they are sure to have a witty anecdote about
how their persistence, or their brilliance, or charisma got them to where they are
now. What we are not seeing is all the people just as witty, just as charismatic
or even just as persistent that where simply not as lucky. Very few people will
tell you this. Because it takes a whole lot of courage to admit that ones
success is based on luck and privilege.

And to take it back to the scientific context: When you are planning an
experiment for the lab, always ask whether your data collection process can in
some way be biased towards what you are trying to show.

I leave you with this:


```{=html}
<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">weird how every time you see this image on twitter it has a ton of retweets <a href="https://t.co/VALAKdeheP">pic.twitter.com/VALAKdeheP</a></p>&mdash; Jake VanderPlas (@jakevdp) <a href="https://twitter.com/jakevdp/status/1336343740235935744?ref_src=twsrc%5Etfw">December 8, 2020</a></blockquote>

```

And from this cautionary tale we jump straight back into RStudio.

## Sidenotes

### Glue and Inline R Code

Using `paste` to create a text in which the
values of variables are inserted can be painful.


```r
name <- "Jannik"
age <- 26
text <- paste(name, "is", age, "years old.")
text
```

```
[1] "Jannik is 26 years old."
```

The `glue` package makes it a breeze.
Everything inside of curly braces in the text inside of the `glue`
function will be evaluated as regular R code,
enabling us to write text quite naturally: 


```r
text <- glue("{name} is {age} years old.")
text
```

```
Jannik is 26 years old.
```

I hope you are not too confused by the package and it's main function having the
same name.


```r
glue("{name} is {age + 10} years old.")
```

```
Jannik is 36 years old.
```

### Inline R code

Using the a backtick followed by the letter `r` we
can add the results of code right into the text sections
of Rmarkdown reports:

1 + 1 = 2.

Jannik is 26 years old.

### Best Practices

Speaking of being careful.
There is one rule I can give you to make your data analysis more secure:

> **Your raw data is sacred!**
  Do not ever modify it or save over it.

This is even more important when,
for example, using excel to preview a csv file.
Under no circumstances should you hit the save button
in excel when you are looking at the raw data.
With approximately one-fifth of genomic research papers containing
errors in the gene lists, because excel converted genes
such as _SEPT2_ (Septin 2) into dates, you can see why [@ziemannGeneNameErrors2016].
Biologists have since given up and renamed the genes that
where commonly converted into dates... but the point still stands.
This caution is of course also necessary when analyzing data
with R, not just excel. When we read in the raw data and
save a processed version, we create a new file, or even
better, a new folder for it. A good convention for example
would be do divide your data into a `raw` and `derived` folder.

## Covariance, Correlation and Regression

![Source: https://xkcd.com/552/](images/correlation.png)

Last week, we talked about a measure of the spread of a
random variable called the **variance**.

$$var(X) = \frac{\sum_{i=0}^{n}{(x_i-\bar x)^2}}{(n-1)}$$

Today, we are extending this idea to 2 random variables.
Because the normal distribution is so common, we are using
two normally distributed variables.



```r
N <- 50
df <- tibble(
  x = rnorm(N),
  y = rnorm(N)
)

m_x <- mean(df$x)
m_y <- mean(df$y)

ggplot(df, aes(x, y)) +
  geom_vline(xintercept = m_x, alpha = 0.8, color = "midnightblue") +
  geom_hline(yintercept = m_y, alpha = 0.8, color = "midnightblue") +
  geom_point(fill = "white", color = "black")
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-6-1.png" width="100%" />

We also added lines for the
means of the two random
variables. Maybe I should have mentioned
this more clearly earlier on,
but the general convention in statistics is that random variables
are uppercase and concrete values from the distribution have the
same letter but lowercase.

We now get the **covariance** of X and Y as:

$$cov(X,Y)=\text{E}\left[(X-\text{E}\left[X\right])(Y-\text{E}\left[Y\right])\right]$$

The expected value $E[X]$ is just a fancy way of saying
the mean of X.
If we asses the contribution of individual points towards the
covariance, we can understand it quite intuitively.
A point that has a higher x than the mean of X and a higher
y than the mean of Y (top right quadrant) will push the covariance towards
positive values. Likewise, a point in the bottom left quadrant
will have negative differences with the X and Y mean, which cancel
each other out to result in a positive covariance.
The bottom right and top left quadrants push towards a negative
covariance. A mix of positive and negative contributions will
result in a covariance with a small absolute value.

The covariance has one problem: It will have weird units
(X times Y) and the scale is different depending on the random
variables.
So what we do is standardize it by dividing by both standard
deviations and get the **correlation coefficient**:

$$cor(X,Y)=\frac{cov(X,Y)}{\sigma_{X}\sigma_{Y}}$$

It can assume values between -1 and 1. It's full name is
_Pearson product-moment correlation coefficient_, or
_pearsons R_. We can square it to get $R^2$ (obviously),
which indicates the strength of the correlation with
values between 0 and 1 independent of the direction.
We will meet it again later.

Let us apply our knowledge to a new dataset.

### Introducing the Dataset

The `dplyr` package includes and example dataset of Star Wars
characters. Unfortunately, it was created a while ago,
so the is no baby yoda, but 87 other characters are present.

![I guess it is the baby yoda show now.](images/baby_yoda.gif)


```r
starwars
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["int"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hair_color"],"name":[4],"type":["chr"],"align":["left"]},{"label":["skin_color"],"name":[5],"type":["chr"],"align":["left"]},{"label":["eye_color"],"name":[6],"type":["chr"],"align":["left"]},{"label":["birth_year"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["sex"],"name":[8],"type":["chr"],"align":["left"]},{"label":["gender"],"name":[9],"type":["chr"],"align":["left"]},{"label":["homeworld"],"name":[10],"type":["chr"],"align":["left"]},{"label":["species"],"name":[11],"type":["chr"],"align":["left"]},{"label":["films"],"name":[12],"type":["list"],"align":["right"]},{"label":["vehicles"],"name":[13],"type":["list"],"align":["right"]},{"label":["starships"],"name":[14],"type":["list"],"align":["right"]}],"data":[{"1":"Luke Skywalker","2":"172","3":"77.0","4":"blond","5":"fair","6":"blue","7":"19.0","8":"male","9":"masculine","10":"Tatooine","11":"Human","12":"<chr [5]>","13":"<chr [2]>","14":"<chr [2]>"},{"1":"C-3PO","2":"167","3":"75.0","4":"NA","5":"gold","6":"yellow","7":"112.0","8":"none","9":"masculine","10":"Tatooine","11":"Droid","12":"<chr [6]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"R2-D2","2":"96","3":"32.0","4":"NA","5":"white, blue","6":"red","7":"33.0","8":"none","9":"masculine","10":"Naboo","11":"Droid","12":"<chr [7]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Darth Vader","2":"202","3":"136.0","4":"none","5":"white","6":"yellow","7":"41.9","8":"male","9":"masculine","10":"Tatooine","11":"Human","12":"<chr [4]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Leia Organa","2":"150","3":"49.0","4":"brown","5":"light","6":"brown","7":"19.0","8":"female","9":"feminine","10":"Alderaan","11":"Human","12":"<chr [5]>","13":"<chr [1]>","14":"<chr [0]>"},{"1":"Owen Lars","2":"178","3":"120.0","4":"brown, grey","5":"light","6":"blue","7":"52.0","8":"male","9":"masculine","10":"Tatooine","11":"Human","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Beru Whitesun lars","2":"165","3":"75.0","4":"brown","5":"light","6":"blue","7":"47.0","8":"female","9":"feminine","10":"Tatooine","11":"Human","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"R5-D4","2":"97","3":"32.0","4":"NA","5":"white, red","6":"red","7":"NA","8":"none","9":"masculine","10":"Tatooine","11":"Droid","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Biggs Darklighter","2":"183","3":"84.0","4":"black","5":"light","6":"brown","7":"24.0","8":"male","9":"masculine","10":"Tatooine","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Obi-Wan Kenobi","2":"182","3":"77.0","4":"auburn, white","5":"fair","6":"blue-gray","7":"57.0","8":"male","9":"masculine","10":"Stewjon","11":"Human","12":"<chr [6]>","13":"<chr [1]>","14":"<chr [5]>"},{"1":"Anakin Skywalker","2":"188","3":"84.0","4":"blond","5":"fair","6":"blue","7":"41.9","8":"male","9":"masculine","10":"Tatooine","11":"Human","12":"<chr [3]>","13":"<chr [2]>","14":"<chr [3]>"},{"1":"Wilhuff Tarkin","2":"180","3":"NA","4":"auburn, grey","5":"fair","6":"blue","7":"64.0","8":"male","9":"masculine","10":"Eriadu","11":"Human","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Chewbacca","2":"228","3":"112.0","4":"brown","5":"unknown","6":"blue","7":"200.0","8":"male","9":"masculine","10":"Kashyyyk","11":"Wookiee","12":"<chr [5]>","13":"<chr [1]>","14":"<chr [2]>"},{"1":"Han Solo","2":"180","3":"80.0","4":"brown","5":"fair","6":"brown","7":"29.0","8":"male","9":"masculine","10":"Corellia","11":"Human","12":"<chr [4]>","13":"<chr [0]>","14":"<chr [2]>"},{"1":"Greedo","2":"173","3":"74.0","4":"NA","5":"green","6":"black","7":"44.0","8":"male","9":"masculine","10":"Rodia","11":"Rodian","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Jabba Desilijic Tiure","2":"175","3":"1358.0","4":"NA","5":"green-tan, brown","6":"orange","7":"600.0","8":"hermaphroditic","9":"masculine","10":"Nal Hutta","11":"Hutt","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Wedge Antilles","2":"170","3":"77.0","4":"brown","5":"fair","6":"hazel","7":"21.0","8":"male","9":"masculine","10":"Corellia","11":"Human","12":"<chr [3]>","13":"<chr [1]>","14":"<chr [1]>"},{"1":"Jek Tono Porkins","2":"180","3":"110.0","4":"brown","5":"fair","6":"blue","7":"NA","8":"male","9":"masculine","10":"Bestine IV","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Yoda","2":"66","3":"17.0","4":"white","5":"green","6":"brown","7":"896.0","8":"male","9":"masculine","10":"NA","11":"Yoda's species","12":"<chr [5]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Palpatine","2":"170","3":"75.0","4":"grey","5":"pale","6":"yellow","7":"82.0","8":"male","9":"masculine","10":"Naboo","11":"Human","12":"<chr [5]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Boba Fett","2":"183","3":"78.2","4":"black","5":"fair","6":"brown","7":"31.5","8":"male","9":"masculine","10":"Kamino","11":"Human","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"IG-88","2":"200","3":"140.0","4":"none","5":"metal","6":"red","7":"15.0","8":"none","9":"masculine","10":"NA","11":"Droid","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Bossk","2":"190","3":"113.0","4":"none","5":"green","6":"red","7":"53.0","8":"male","9":"masculine","10":"Trandosha","11":"Trandoshan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Lando Calrissian","2":"177","3":"79.0","4":"black","5":"dark","6":"brown","7":"31.0","8":"male","9":"masculine","10":"Socorro","11":"Human","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Lobot","2":"175","3":"79.0","4":"none","5":"light","6":"blue","7":"37.0","8":"male","9":"masculine","10":"Bespin","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Ackbar","2":"180","3":"83.0","4":"none","5":"brown mottle","6":"orange","7":"41.0","8":"male","9":"masculine","10":"Mon Cala","11":"Mon Calamari","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Mon Mothma","2":"150","3":"NA","4":"auburn","5":"fair","6":"blue","7":"48.0","8":"female","9":"feminine","10":"Chandrila","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Arvel Crynyd","2":"NA","3":"NA","4":"brown","5":"fair","6":"brown","7":"NA","8":"male","9":"masculine","10":"NA","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Wicket Systri Warrick","2":"88","3":"20.0","4":"brown","5":"brown","6":"brown","7":"8.0","8":"male","9":"masculine","10":"Endor","11":"Ewok","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Nien Nunb","2":"160","3":"68.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"masculine","10":"Sullust","11":"Sullustan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Qui-Gon Jinn","2":"193","3":"89.0","4":"brown","5":"fair","6":"blue","7":"92.0","8":"male","9":"masculine","10":"NA","11":"Human","12":"<chr [1]>","13":"<chr [1]>","14":"<chr [0]>"},{"1":"Nute Gunray","2":"191","3":"90.0","4":"none","5":"mottled green","6":"red","7":"NA","8":"male","9":"masculine","10":"Cato Neimoidia","11":"Neimodian","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Finis Valorum","2":"170","3":"NA","4":"blond","5":"fair","6":"blue","7":"91.0","8":"male","9":"masculine","10":"Coruscant","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Jar Jar Binks","2":"196","3":"66.0","4":"none","5":"orange","6":"orange","7":"52.0","8":"male","9":"masculine","10":"Naboo","11":"Gungan","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Roos Tarpals","2":"224","3":"82.0","4":"none","5":"grey","6":"orange","7":"NA","8":"male","9":"masculine","10":"Naboo","11":"Gungan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Rugor Nass","2":"206","3":"NA","4":"none","5":"green","6":"orange","7":"NA","8":"male","9":"masculine","10":"Naboo","11":"Gungan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Ric Olié","2":"183","3":"NA","4":"brown","5":"fair","6":"blue","7":"NA","8":"NA","9":"NA","10":"Naboo","11":"NA","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Watto","2":"137","3":"NA","4":"black","5":"blue, grey","6":"yellow","7":"NA","8":"male","9":"masculine","10":"Toydaria","11":"Toydarian","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Sebulba","2":"112","3":"40.0","4":"none","5":"grey, red","6":"orange","7":"NA","8":"male","9":"masculine","10":"Malastare","11":"Dug","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Quarsh Panaka","2":"183","3":"NA","4":"black","5":"dark","6":"brown","7":"62.0","8":"NA","9":"NA","10":"Naboo","11":"NA","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Shmi Skywalker","2":"163","3":"NA","4":"black","5":"fair","6":"brown","7":"72.0","8":"female","9":"feminine","10":"Tatooine","11":"Human","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Darth Maul","2":"175","3":"80.0","4":"none","5":"red","6":"yellow","7":"54.0","8":"male","9":"masculine","10":"Dathomir","11":"Zabrak","12":"<chr [1]>","13":"<chr [1]>","14":"<chr [1]>"},{"1":"Bib Fortuna","2":"180","3":"NA","4":"none","5":"pale","6":"pink","7":"NA","8":"male","9":"masculine","10":"Ryloth","11":"Twi'lek","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Ayla Secura","2":"178","3":"55.0","4":"none","5":"blue","6":"hazel","7":"48.0","8":"female","9":"feminine","10":"Ryloth","11":"Twi'lek","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Dud Bolt","2":"94","3":"45.0","4":"none","5":"blue, grey","6":"yellow","7":"NA","8":"male","9":"masculine","10":"Vulpter","11":"Vulptereen","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Gasgano","2":"122","3":"NA","4":"none","5":"white, blue","6":"black","7":"NA","8":"male","9":"masculine","10":"Troiken","11":"Xexto","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Ben Quadinaros","2":"163","3":"65.0","4":"none","5":"grey, green, yellow","6":"orange","7":"NA","8":"male","9":"masculine","10":"Tund","11":"Toong","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Mace Windu","2":"188","3":"84.0","4":"none","5":"dark","6":"brown","7":"72.0","8":"male","9":"masculine","10":"Haruun Kal","11":"Human","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Ki-Adi-Mundi","2":"198","3":"82.0","4":"white","5":"pale","6":"yellow","7":"92.0","8":"male","9":"masculine","10":"Cerea","11":"Cerean","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Kit Fisto","2":"196","3":"87.0","4":"none","5":"green","6":"black","7":"NA","8":"male","9":"masculine","10":"Glee Anselm","11":"Nautolan","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Eeth Koth","2":"171","3":"NA","4":"black","5":"brown","6":"brown","7":"NA","8":"male","9":"masculine","10":"Iridonia","11":"Zabrak","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Adi Gallia","2":"184","3":"50.0","4":"none","5":"dark","6":"blue","7":"NA","8":"female","9":"feminine","10":"Coruscant","11":"Tholothian","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Saesee Tiin","2":"188","3":"NA","4":"none","5":"pale","6":"orange","7":"NA","8":"male","9":"masculine","10":"Iktotch","11":"Iktotchi","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Yarael Poof","2":"264","3":"NA","4":"none","5":"white","6":"yellow","7":"NA","8":"male","9":"masculine","10":"Quermia","11":"Quermian","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Plo Koon","2":"188","3":"80.0","4":"none","5":"orange","6":"black","7":"22.0","8":"male","9":"masculine","10":"Dorin","11":"Kel Dor","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Mas Amedda","2":"196","3":"NA","4":"none","5":"blue","6":"blue","7":"NA","8":"male","9":"masculine","10":"Champala","11":"Chagrian","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Gregar Typho","2":"185","3":"85.0","4":"black","5":"dark","6":"brown","7":"NA","8":"male","9":"masculine","10":"Naboo","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"Cordé","2":"157","3":"NA","4":"brown","5":"light","6":"brown","7":"NA","8":"female","9":"feminine","10":"Naboo","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Cliegg Lars","2":"183","3":"NA","4":"brown","5":"fair","6":"blue","7":"82.0","8":"male","9":"masculine","10":"Tatooine","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Poggle the Lesser","2":"183","3":"80.0","4":"none","5":"green","6":"yellow","7":"NA","8":"male","9":"masculine","10":"Geonosis","11":"Geonosian","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Luminara Unduli","2":"170","3":"56.2","4":"black","5":"yellow","6":"blue","7":"58.0","8":"female","9":"feminine","10":"Mirial","11":"Mirialan","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Barriss Offee","2":"166","3":"50.0","4":"black","5":"yellow","6":"blue","7":"40.0","8":"female","9":"feminine","10":"Mirial","11":"Mirialan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Dormé","2":"165","3":"NA","4":"brown","5":"light","6":"brown","7":"NA","8":"female","9":"feminine","10":"Naboo","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Dooku","2":"193","3":"80.0","4":"white","5":"fair","6":"brown","7":"102.0","8":"male","9":"masculine","10":"Serenno","11":"Human","12":"<chr [2]>","13":"<chr [1]>","14":"<chr [0]>"},{"1":"Bail Prestor Organa","2":"191","3":"NA","4":"black","5":"tan","6":"brown","7":"67.0","8":"male","9":"masculine","10":"Alderaan","11":"Human","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Jango Fett","2":"183","3":"79.0","4":"black","5":"tan","6":"brown","7":"66.0","8":"male","9":"masculine","10":"Concord Dawn","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Zam Wesell","2":"168","3":"55.0","4":"blonde","5":"fair, green, yellow","6":"yellow","7":"NA","8":"female","9":"feminine","10":"Zolan","11":"Clawdite","12":"<chr [1]>","13":"<chr [1]>","14":"<chr [0]>"},{"1":"Dexter Jettster","2":"198","3":"102.0","4":"none","5":"brown","6":"yellow","7":"NA","8":"male","9":"masculine","10":"Ojom","11":"Besalisk","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Lama Su","2":"229","3":"88.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"masculine","10":"Kamino","11":"Kaminoan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Taun We","2":"213","3":"NA","4":"none","5":"grey","6":"black","7":"NA","8":"female","9":"feminine","10":"Kamino","11":"Kaminoan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Jocasta Nu","2":"167","3":"NA","4":"white","5":"fair","6":"blue","7":"NA","8":"female","9":"feminine","10":"Coruscant","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Ratts Tyerell","2":"79","3":"15.0","4":"none","5":"grey, blue","6":"unknown","7":"NA","8":"male","9":"masculine","10":"Aleen Minor","11":"Aleena","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"R4-P17","2":"96","3":"NA","4":"none","5":"silver, red","6":"red, blue","7":"NA","8":"none","9":"feminine","10":"NA","11":"Droid","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Wat Tambor","2":"193","3":"48.0","4":"none","5":"green, grey","6":"unknown","7":"NA","8":"male","9":"masculine","10":"Skako","11":"Skakoan","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"San Hill","2":"191","3":"NA","4":"none","5":"grey","6":"gold","7":"NA","8":"male","9":"masculine","10":"Muunilinst","11":"Muun","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Shaak Ti","2":"178","3":"57.0","4":"none","5":"red, blue, white","6":"black","7":"NA","8":"female","9":"feminine","10":"Shili","11":"Togruta","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Grievous","2":"216","3":"159.0","4":"none","5":"brown, white","6":"green, yellow","7":"NA","8":"male","9":"masculine","10":"Kalee","11":"Kaleesh","12":"<chr [1]>","13":"<chr [1]>","14":"<chr [1]>"},{"1":"Tarfful","2":"234","3":"136.0","4":"brown","5":"brown","6":"blue","7":"NA","8":"male","9":"masculine","10":"Kashyyyk","11":"Wookiee","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Raymus Antilles","2":"188","3":"79.0","4":"brown","5":"light","6":"brown","7":"NA","8":"male","9":"masculine","10":"Alderaan","11":"Human","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Sly Moore","2":"178","3":"48.0","4":"none","5":"pale","6":"white","7":"NA","8":"NA","9":"NA","10":"Umbara","11":"NA","12":"<chr [2]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Tion Medon","2":"206","3":"80.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"masculine","10":"Utapau","11":"Pau'an","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Finn","2":"NA","3":"NA","4":"black","5":"dark","6":"dark","7":"NA","8":"male","9":"masculine","10":"NA","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Rey","2":"NA","3":"NA","4":"brown","5":"light","6":"hazel","7":"NA","8":"female","9":"feminine","10":"NA","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Poe Dameron","2":"NA","3":"NA","4":"brown","5":"light","6":"brown","7":"NA","8":"male","9":"masculine","10":"NA","11":"Human","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [1]>"},{"1":"BB8","2":"NA","3":"NA","4":"none","5":"none","6":"black","7":"NA","8":"none","9":"masculine","10":"NA","11":"Droid","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Captain Phasma","2":"NA","3":"NA","4":"unknown","5":"unknown","6":"unknown","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"<chr [1]>","13":"<chr [0]>","14":"<chr [0]>"},{"1":"Padmé Amidala","2":"165","3":"45.0","4":"brown","5":"light","6":"brown","7":"46.0","8":"female","9":"feminine","10":"Naboo","11":"Human","12":"<chr [3]>","13":"<chr [0]>","14":"<chr [3]>"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Let's look at some correlations:

### Pearson vs. Spearman (not a Boxing Match)

To compute pearsons correlation, we use the `cor` function in R.
Instead of filtering out `NA`, we can use
`use = "complete.obs"` to ignore rows with missing values in the computation.


```r
pearson <- cor(starwars$height, starwars$mass, use = "complete.obs")
pearson
```

```
[1] 0.1338842
```

When I first did this I was surprised that the correlation was so
low. We are after all talking about height and mass, which
I assumed to be highly correlated.
Let us look at the data to see what is going on.


```r
label_text <- glue("Pearson correlation: {round(pearson, 2)}")

jabba <- filter(starwars, str_detect(name, "Jabba"))
jabba_text <- list(x = 1100, y = 120)

starwars %>% 
  ggplot(aes(mass, height)) +
  geom_point() +
  annotate(geom = "text", x = 500, y = 75, label = label_text,
           hjust = 0) +
  annotate(geom = "curve",
           x = jabba_text$x, y = jabba_text$y,
           xend = jabba$mass, yend = jabba$height,
           curvature = .3,
           arrow = arrow(length = unit(2, "mm"))) +
  annotate(geom = "text",
           x = jabba_text$x,
           y = jabba_text$y, label = "Jabba the Hutt",
           hjust = 1.1) +
  xlim(0, 1500) +
  labs(x = "mass [kg]",
       y = "height [cm]")
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-9-1.png" width="100%" />

This is the culprit! We have a massive outlier,
in all senses of the word "massive".
Luckily, there is another method to asses correlation.
Spearman's method is more resistant to outliers,
because the data is transformed into ranks first,
which negates the massive effect of outliers.



```r
spearman <- cor(starwars$height, starwars$mass,
                use = "complete.obs", method = "spearman")
spearman
```

```
[1] 0.7516794
```

Visually, this is what the points look like
after rank transformation:


```r
label_text <- glue("Spearman rank correlation: {round(spearman, 2)}")

starwars %>% 
  mutate(mass = rank(mass),
         height = rank(height)) %>% 
  ggplot(aes(mass, height)) +
  geom_point() +
  annotate(geom = "text", x = 0, y = 75, label = label_text,
           hjust = 0) +
  labs(x = "rank(mass)",
       y = "rank(height)")
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-11-1.png" width="100%" />

Apart from `cor`, there is also `cor.test`, which gives more information. 
If we so fancy, we can use `broom` to turn the test output into
a tidy format as well.


```r
cortest <- cor.test(starwars$mass, starwars$height,
                # method = "spearman",
                use = "complete.obs")

cortest
```

```

	Pearson's product-moment correlation

data:  starwars$mass and starwars$height
t = 1.02, df = 57, p-value = 0.312
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.1265364  0.3770395
sample estimates:
      cor 
0.1338842 
```


```r
tidy(cortest)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["estimate"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["statistic"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["p.value"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["parameter"],"name":[4],"type":["int"],"align":["right"]},{"label":["conf.low"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["conf.high"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["method"],"name":[7],"type":["chr"],"align":["left"]},{"label":["alternative"],"name":[8],"type":["chr"],"align":["left"]}],"data":[{"1":"0.1338842","2":"1.019986","3":"0.3120447","4":"57","5":"-0.1265364","6":"0.3770395","7":"Pearson's product-moment correlation","8":"two.sided","_row":"cor"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

There is another way we can specify which features to correlate.
`corr` also takes a matrix or data frame as it's x argument instead
of x and y.
We then end up with the pairwise correlation coefficients
for all columns of the dataframe.

This is known as a correlation matrix, and we can create it for
more than two features, as long as all features are numeric
(after all, what is the correlation between 1,4 and "cat" "dog"?).
Unfortunately there are only three numeric columns
in the `starwars` dataset, which makes for a pretty boring
correlation matrix.


```r
starwars %>%
  select(where(is.numeric)) %>% 
  head()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["height"],"name":[1],"type":["int"],"align":["right"]},{"label":["mass"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["birth_year"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"172","2":"77","3":"19.0"},{"1":"167","2":"75","3":"112.0"},{"1":"96","2":"32","3":"33.0"},{"1":"202","2":"136","3":"41.9"},{"1":"150","2":"49","3":"19.0"},{"1":"178","2":"120","3":"52.0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

So let's look at another built-in dataset instead.
`mtcars` has some data about cars, like their
engine displacement or miles per gallon.


```r
mtcars %>% 
  ggplot(aes(disp, mpg)) +
  geom_point()
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-15-1.png" width="100%" />

This makes for a much more interesting correlation matrix:


```r
cor(mtcars) %>% 
  as_tibble(rownames = "feature") %>% 
  pivot_longer(-feature) %>% 
  ggplot(aes(feature, name, fill = value)) +
  geom_raster() +
  geom_text(aes(label = round(value, 2))) +
  scale_fill_gradient2(low = "blue", high = "red",
                       mid = "white", midpoint = 0)
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-16-1.png" width="100%" />

If you are working a lot with correlations, it is certainly
worth checking out the `corrr` package from the tidymodels framework:

<aside>
<a href="https://corrr.tidymodels.org/">
![](images/corrr.png){width=200}
</a>
</aside>

Its functions make these steps easier.


```r
corrr::correlate(mtcars) %>% 
  corrr::stretch()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["x"],"name":[1],"type":["chr"],"align":["left"]},{"label":["y"],"name":[2],"type":["chr"],"align":["left"]},{"label":["r"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"mpg","2":"mpg","3":"NA"},{"1":"mpg","2":"cyl","3":"-0.85216196"},{"1":"mpg","2":"disp","3":"-0.84755138"},{"1":"mpg","2":"hp","3":"-0.77616837"},{"1":"mpg","2":"drat","3":"0.68117191"},{"1":"mpg","2":"wt","3":"-0.86765938"},{"1":"mpg","2":"qsec","3":"0.41868403"},{"1":"mpg","2":"vs","3":"0.66403892"},{"1":"mpg","2":"am","3":"0.59983243"},{"1":"mpg","2":"gear","3":"0.48028476"},{"1":"mpg","2":"carb","3":"-0.55092507"},{"1":"cyl","2":"mpg","3":"-0.85216196"},{"1":"cyl","2":"cyl","3":"NA"},{"1":"cyl","2":"disp","3":"0.90203287"},{"1":"cyl","2":"hp","3":"0.83244745"},{"1":"cyl","2":"drat","3":"-0.69993811"},{"1":"cyl","2":"wt","3":"0.78249579"},{"1":"cyl","2":"qsec","3":"-0.59124207"},{"1":"cyl","2":"vs","3":"-0.81081180"},{"1":"cyl","2":"am","3":"-0.52260705"},{"1":"cyl","2":"gear","3":"-0.49268660"},{"1":"cyl","2":"carb","3":"0.52698829"},{"1":"disp","2":"mpg","3":"-0.84755138"},{"1":"disp","2":"cyl","3":"0.90203287"},{"1":"disp","2":"disp","3":"NA"},{"1":"disp","2":"hp","3":"0.79094859"},{"1":"disp","2":"drat","3":"-0.71021393"},{"1":"disp","2":"wt","3":"0.88797992"},{"1":"disp","2":"qsec","3":"-0.43369788"},{"1":"disp","2":"vs","3":"-0.71041589"},{"1":"disp","2":"am","3":"-0.59122704"},{"1":"disp","2":"gear","3":"-0.55556920"},{"1":"disp","2":"carb","3":"0.39497686"},{"1":"hp","2":"mpg","3":"-0.77616837"},{"1":"hp","2":"cyl","3":"0.83244745"},{"1":"hp","2":"disp","3":"0.79094859"},{"1":"hp","2":"hp","3":"NA"},{"1":"hp","2":"drat","3":"-0.44875912"},{"1":"hp","2":"wt","3":"0.65874789"},{"1":"hp","2":"qsec","3":"-0.70822339"},{"1":"hp","2":"vs","3":"-0.72309674"},{"1":"hp","2":"am","3":"-0.24320426"},{"1":"hp","2":"gear","3":"-0.12570426"},{"1":"hp","2":"carb","3":"0.74981247"},{"1":"drat","2":"mpg","3":"0.68117191"},{"1":"drat","2":"cyl","3":"-0.69993811"},{"1":"drat","2":"disp","3":"-0.71021393"},{"1":"drat","2":"hp","3":"-0.44875912"},{"1":"drat","2":"drat","3":"NA"},{"1":"drat","2":"wt","3":"-0.71244065"},{"1":"drat","2":"qsec","3":"0.09120476"},{"1":"drat","2":"vs","3":"0.44027846"},{"1":"drat","2":"am","3":"0.71271113"},{"1":"drat","2":"gear","3":"0.69961013"},{"1":"drat","2":"carb","3":"-0.09078980"},{"1":"wt","2":"mpg","3":"-0.86765938"},{"1":"wt","2":"cyl","3":"0.78249579"},{"1":"wt","2":"disp","3":"0.88797992"},{"1":"wt","2":"hp","3":"0.65874789"},{"1":"wt","2":"drat","3":"-0.71244065"},{"1":"wt","2":"wt","3":"NA"},{"1":"wt","2":"qsec","3":"-0.17471588"},{"1":"wt","2":"vs","3":"-0.55491568"},{"1":"wt","2":"am","3":"-0.69249526"},{"1":"wt","2":"gear","3":"-0.58328700"},{"1":"wt","2":"carb","3":"0.42760594"},{"1":"qsec","2":"mpg","3":"0.41868403"},{"1":"qsec","2":"cyl","3":"-0.59124207"},{"1":"qsec","2":"disp","3":"-0.43369788"},{"1":"qsec","2":"hp","3":"-0.70822339"},{"1":"qsec","2":"drat","3":"0.09120476"},{"1":"qsec","2":"wt","3":"-0.17471588"},{"1":"qsec","2":"qsec","3":"NA"},{"1":"qsec","2":"vs","3":"0.74453544"},{"1":"qsec","2":"am","3":"-0.22986086"},{"1":"qsec","2":"gear","3":"-0.21268223"},{"1":"qsec","2":"carb","3":"-0.65624923"},{"1":"vs","2":"mpg","3":"0.66403892"},{"1":"vs","2":"cyl","3":"-0.81081180"},{"1":"vs","2":"disp","3":"-0.71041589"},{"1":"vs","2":"hp","3":"-0.72309674"},{"1":"vs","2":"drat","3":"0.44027846"},{"1":"vs","2":"wt","3":"-0.55491568"},{"1":"vs","2":"qsec","3":"0.74453544"},{"1":"vs","2":"vs","3":"NA"},{"1":"vs","2":"am","3":"0.16834512"},{"1":"vs","2":"gear","3":"0.20602335"},{"1":"vs","2":"carb","3":"-0.56960714"},{"1":"am","2":"mpg","3":"0.59983243"},{"1":"am","2":"cyl","3":"-0.52260705"},{"1":"am","2":"disp","3":"-0.59122704"},{"1":"am","2":"hp","3":"-0.24320426"},{"1":"am","2":"drat","3":"0.71271113"},{"1":"am","2":"wt","3":"-0.69249526"},{"1":"am","2":"qsec","3":"-0.22986086"},{"1":"am","2":"vs","3":"0.16834512"},{"1":"am","2":"am","3":"NA"},{"1":"am","2":"gear","3":"0.79405876"},{"1":"am","2":"carb","3":"0.05753435"},{"1":"gear","2":"mpg","3":"0.48028476"},{"1":"gear","2":"cyl","3":"-0.49268660"},{"1":"gear","2":"disp","3":"-0.55556920"},{"1":"gear","2":"hp","3":"-0.12570426"},{"1":"gear","2":"drat","3":"0.69961013"},{"1":"gear","2":"wt","3":"-0.58328700"},{"1":"gear","2":"qsec","3":"-0.21268223"},{"1":"gear","2":"vs","3":"0.20602335"},{"1":"gear","2":"am","3":"0.79405876"},{"1":"gear","2":"gear","3":"NA"},{"1":"gear","2":"carb","3":"0.27407284"},{"1":"carb","2":"mpg","3":"-0.55092507"},{"1":"carb","2":"cyl","3":"0.52698829"},{"1":"carb","2":"disp","3":"0.39497686"},{"1":"carb","2":"hp","3":"0.74981247"},{"1":"carb","2":"drat","3":"-0.09078980"},{"1":"carb","2":"wt","3":"0.42760594"},{"1":"carb","2":"qsec","3":"-0.65624923"},{"1":"carb","2":"vs","3":"-0.56960714"},{"1":"carb","2":"am","3":"0.05753435"},{"1":"carb","2":"gear","3":"0.27407284"},{"1":"carb","2":"carb","3":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

And give use access to two different types of plots out of the box.


```r
corrr::correlate(mtcars) %>% 
  corrr::rplot()
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-18-1.png" width="100%" />



```r
corrr::correlate(mtcars) %>% 
  corrr::network_plot()
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-19-1.png" width="100%" />

### Difference to Linear Regression

Finally, linear regression is
a related concept, because both correlation and
linear regression quantify the strength of a linear
relationship. However, there are key differences.
When we fit a linear model like:

$$y \sim a + x * b$$

there is no error in x. We assume x is something that
is fixed, like the temperature we set for an experiment
or the dosage we used. Y on the other hand is a random
variable. In `cov(X,Y)` and `cor(X,Y)`, X and Y are both random variables,
usually things we observed, not set ourselves.

While the correlation coefficient is symmetrical and translation-scale-invariant:

$$cor(X,Y)=cor(Y,X)$$



$$cor(X,Y)=cor(X * a +b,Y * c + d)$$

The same is **not** true for linear models!

Let us look at an example where linear regression
is more appropriate than correlation.
In the `data` folder we find the IMDB ratings for 10
Star Wars movies (plus more features).



```r
ratings <- read_rds("data/07/starwars_movies.rds")
ratings
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Title"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Rated"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Released"],"name":[3],"type":["date"],"align":["right"]},{"label":["Runtime"],"name":[4],"type":["chr"],"align":["left"]},{"label":["Genre"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Director"],"name":[6],"type":["chr"],"align":["left"]},{"label":["Writer"],"name":[7],"type":["chr"],"align":["left"]},{"label":["Actors"],"name":[8],"type":["chr"],"align":["left"]},{"label":["Plot"],"name":[9],"type":["chr"],"align":["left"]},{"label":["Language"],"name":[10],"type":["chr"],"align":["left"]},{"label":["Country"],"name":[11],"type":["chr"],"align":["left"]},{"label":["Awards"],"name":[12],"type":["chr"],"align":["left"]},{"label":["Poster"],"name":[13],"type":["chr"],"align":["left"]},{"label":["Ratings"],"name":[14],"type":["list"],"align":["right"]},{"label":["Metascore"],"name":[15],"type":["chr"],"align":["left"]},{"label":["imdbRating"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["imdbVotes"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["imdbID"],"name":[18],"type":["chr"],"align":["left"]},{"label":["Type"],"name":[19],"type":["chr"],"align":["left"]},{"label":["DVD"],"name":[20],"type":["date"],"align":["right"]},{"label":["BoxOffice"],"name":[21],"type":["chr"],"align":["left"]},{"label":["Production"],"name":[22],"type":["chr"],"align":["left"]},{"label":["Website"],"name":[23],"type":["chr"],"align":["left"]},{"label":["Response"],"name":[24],"type":["chr"],"align":["left"]},{"label":["year"],"name":[25],"type":["dbl"],"align":["right"]}],"data":[{"1":"Star Wars: Episode IV - A New Hope","2":"PG","3":"1977-05-25","4":"121 min","5":"Action, Adventure, Fantasy","6":"George Lucas","7":"George Lucas","8":"Mark Hamill, Harrison Ford, Carrie Fisher","9":"Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vad","10":"English","11":"United States, United Kingdom","12":"Won 7 Oscars. 63 wins & 29 nominations total","13":"https://m.media-amazon.com/images/M/MV5BNzVlY2MwMjktM2E4OS00Y2Y3LWE3ZjctYzhkZGM3YzA1ZWM2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg","14":"<named list [2]>","15":"90","16":"8.6","17":"1286115","18":"tt0076759","19":"movie","20":"2005-12-06","21":"$460,998,507","22":"N/A","23":"N/A","24":"True","25":"1977"},{"1":"Star Wars: Episode V - The Empire Strikes Back","2":"PG","3":"1980-06-20","4":"124 min","5":"Action, Adventure, Fantasy","6":"Irvin Kershner","7":"Leigh Brackett, Lawrence Kasdan, George Lucas","8":"Mark Hamill, Harrison Ford, Carrie Fisher","9":"After the Rebels are brutally overpowered by the Empire on the ice planet Hoth, Luke Skywalker begins Jedi training with Yoda, while his friends are pursued across the galaxy by Darth Vader and bounty hunter Boba Fett.","10":"English","11":"United States, United Kingdom","12":"Won 2 Oscars. 25 wins & 20 nominations total","13":"https://m.media-amazon.com/images/M/MV5BYmU1NDRjNDgtMzhiMi00NjZmLTg5NGItZDNiZjU5NTU4OTE0XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg","14":"<named list [2]>","15":"82","16":"8.7","17":"1214530","18":"tt0080684","19":"movie","20":"2004-09-21","21":"$292,753,960","22":"N/A","23":"N/A","24":"True","25":"1980"},{"1":"Star Wars: Episode VI - Return of the Jedi","2":"PG","3":"1983-05-25","4":"131 min","5":"Action, Adventure, Fantasy","6":"Richard Marquand","7":"Lawrence Kasdan, George Lucas","8":"Mark Hamill, Harrison Ford, Carrie Fisher","9":"After a daring mission to rescue Han Solo from Jabba the Hutt, the Rebels dispatch to Endor to destroy the second Death Star. Meanwhile, Luke struggles to help Darth Vader back from the dark side without falling into the Emperor's tr","10":"English","11":"United States, United Kingdom","12":"Won 1 Oscar. 22 wins & 20 nominations total","13":"https://m.media-amazon.com/images/M/MV5BOWZlMjFiYzgtMTUzNC00Y2IzLTk1NTMtZmNhMTczNTk0ODk1XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg","14":"<named list [2]>","15":"58","16":"8.3","17":"993883","18":"tt0086190","19":"movie","20":"2004-09-21","21":"$309,306,177","22":"N/A","23":"N/A","24":"True","25":"1983"},{"1":"Star Wars: Episode VII - The Force Awakens","2":"PG-13","3":"2015-12-18","4":"138 min","5":"Action, Adventure, Sci-Fi","6":"J.J. Abrams","7":"Lawrence Kasdan, J.J. Abrams, Michael Arndt","8":"Daisy Ridley, John Boyega, Oscar Isaac","9":"As a new threat to the galaxy rises, Rey, a desert scavenger, and Finn, an ex-stormtrooper, must join Han Solo and Chewbacca to search for the one hope of restoring peace.","10":"English","11":"United States","12":"Nominated for 5 Oscars. 62 wins & 136 nominations total","13":"https://m.media-amazon.com/images/M/MV5BOTAzODEzNDAzMl5BMl5BanBnXkFtZTgwMDU1MTgzNzE@._V1_SX300.jpg","14":"<named list [2]>","15":"80","16":"7.8","17":"890483","18":"tt2488496","19":"movie","20":"2016-04-05","21":"$936,662,225","22":"N/A","23":"N/A","24":"True","25":"2015"},{"1":"Star Wars: Episode I - The Phantom Menace","2":"PG","3":"1999-05-19","4":"136 min","5":"Action, Adventure, Fantasy","6":"George Lucas","7":"George Lucas","8":"Ewan McGregor, Liam Neeson, Natalie Portman","9":"Two Jedi escape a hostile blockade to find allies and come across a young boy who may bring balance to the Force, but the long dormant Sith resurface to claim their original glory.","10":"English, Sanskrit","11":"United States","12":"Nominated for 3 Oscars. 26 wins & 69 nominations total","13":"https://m.media-amazon.com/images/M/MV5BYTRhNjcwNWQtMGJmMi00NmQyLWE2YzItODVmMTdjNWI0ZDA2XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg","14":"<named list [2]>","15":"51","16":"6.5","17":"761049","18":"tt0120915","19":"movie","20":"2005-03-22","21":"$474,544,677","22":"N/A","23":"N/A","24":"True","25":"1999"},{"1":"Star Wars: Episode III - Revenge of the Sith","2":"PG-13","3":"2005-05-19","4":"140 min","5":"Action, Adventure, Fantasy","6":"George Lucas","7":"George Lucas, John Ostrander, Jan Duursema","8":"Hayden Christensen, Natalie Portman, Ewan McGregor","9":"Three years into the Clone Wars, the Jedi rescue Palpatine from Count Dooku. As Obi-Wan pursues a new threat, Anakin acts as a double agent between the Jedi Council and Palpatine and is lured into a sinister plan to rule the galaxy.","10":"English","11":"United States","12":"Nominated for 1 Oscar. 26 wins & 63 nominations total","13":"https://m.media-amazon.com/images/M/MV5BNTc4MTc3NTQ5OF5BMl5BanBnXkFtZTcwOTg0NjI4NA@@._V1_SX300.jpg","14":"<named list [2]>","15":"68","16":"7.5","17":"742974","18":"tt0121766","19":"movie","20":"2005-11-01","21":"$380,270,577","22":"N/A","23":"N/A","24":"True","25":"2005"},{"1":"Star Wars: Episode II - Attack of the Clones","2":"PG","3":"2002-05-16","4":"142 min","5":"Action, Adventure, Fantasy","6":"George Lucas","7":"George Lucas, Jonathan Hales, John Ostrander","8":"Hayden Christensen, Natalie Portman, Ewan McGregor","9":"Ten years after initially meeting, Anakin Skywalker shares a forbidden romance with Padmé Amidala, while Obi-Wan Kenobi investigates an assassination attempt on the senator and discovers a secret clone army crafted for the Jedi.","10":"English","11":"United States","12":"Nominated for 1 Oscar. 19 wins & 65 nominations total","13":"https://m.media-amazon.com/images/M/MV5BMDAzM2M0Y2UtZjRmZi00MzVlLTg4MjEtOTE3NzU5ZDVlMTU5XkEyXkFqcGdeQXVyNDUyOTg3Njg@._V1_SX300.jpg","14":"<named list [2]>","15":"54","16":"6.5","17":"670516","18":"tt0121765","19":"movie","20":"2005-03-22","21":"$310,676,740","22":"N/A","23":"N/A","24":"True","25":"2002"},{"1":"Star Wars: Episode VIII - The Last Jedi","2":"PG-13","3":"2017-12-15","4":"152 min","5":"Action, Adventure, Fantasy","6":"Rian Johnson","7":"Rian Johnson, George Lucas","8":"Daisy Ridley, John Boyega, Mark Hamill","9":"The Star Wars saga continues as new heroes and galactic legends go on an epic adventure, unlocking mysteries of the Force and shocking revelations of the past.","10":"English","11":"United States","12":"Nominated for 4 Oscars. 25 wins & 99 nominations total","13":"https://m.media-amazon.com/images/M/MV5BMjQ1MzcxNjg4N15BMl5BanBnXkFtZTgwNzgwMjY4MzI@._V1_SX300.jpg","14":"<named list [2]>","15":"84","16":"6.9","17":"593088","18":"tt2527336","19":"movie","20":"2018-03-27","21":"$620,181,382","22":"N/A","23":"N/A","24":"True","25":"2017"},{"1":"Rogue One: A Star Wars Story","2":"PG-13","3":"2016-12-16","4":"133 min","5":"Action, Adventure, Sci-Fi","6":"Gareth Edwards","7":"Chris Weitz, Tony Gilroy, John Knoll","8":"Felicity Jones, Diego Luna, Alan Tudyk","9":"In a time of conflict, a group of unlikely heroes band together on a mission to steal the plans to the Death Star, the Empire's ultimate weapon of destruction.","10":"English","11":"United States","12":"Nominated for 2 Oscars. 24 wins & 83 nominations total","13":"https://m.media-amazon.com/images/M/MV5BMjEwMzMxODIzOV5BMl5BanBnXkFtZTgwNzg3OTAzMDI@._V1_SX300.jpg","14":"<named list [2]>","15":"65","16":"7.8","17":"585512","18":"tt3748528","19":"movie","20":"2017-04-04","21":"$532,177,324","22":"N/A","23":"N/A","24":"True","25":"2016"},{"1":"Star Wars: Episode IX - The Rise of Skywalker","2":"PG-13","3":"2019-12-20","4":"141 min","5":"Action, Adventure, Fantasy","6":"J.J. Abrams","7":"Chris Terrio, J.J. Abrams, Derek Connolly","8":"Daisy Ridley, John Boyega, Oscar Isaac","9":"In the riveting conclusion of the landmark Skywalker saga, new legends will be born-and the final battle for freedom is yet to come.","10":"English","11":"United States","12":"Nominated for 3 Oscars. 16 wins & 54 nominations total","13":"https://m.media-amazon.com/images/M/MV5BMDljNTQ5ODItZmQwMy00M2ExLTljOTQtZTVjNGE2NTg0NGIxXkEyXkFqcGdeQXVyODkzNTgxMDg@._V1_SX300.jpg","14":"<named list [2]>","15":"53","16":"6.6","17":"408000","18":"tt2527338","19":"movie","20":"2019-12-20","21":"$515,202,542","22":"N/A","23":"N/A","24":"True","25":"2019"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

We can fit a linear model to see if the production year
has an effect on the rating.


```r
model <- lm(imdbRating ~ year, data = ratings)

augment(model) %>% 
  ggplot(aes(year, imdbRating)) +
  geom_smooth(method = "lm", alpha = 0.3, color = "midnightblue") +
  geom_segment(aes(x = year, y = .fitted,
                   xend = year, yend = imdbRating),
               alpha = 0.4) +
  geom_point()
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-21-1.png" width="100%" />

What I added here as gray segments are the so called **residuals**.
They are what makes linear regression work.
It's full name is **Ordinary Least Squares** and the squares in
question are the squares of these residuals, the word _least_
indicates that these squares are minimized in order to find the
best fit line.


```r
broom::tidy(model)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["term"],"name":[1],"type":["chr"],"align":["left"]},{"label":["estimate"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["std.error"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["statistic"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["p.value"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"(Intercept)","2":"77.13043478","3":"28.29937462","4":"2.725517","5":"0.02602562"},{"1":"year","2":"-0.03478261","3":"0.01414008","4":"-2.459860","5":"0.03932737"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Looks like every year decreases the estimated rating by 0.03.

One thing however is the same between correlation and
linear regression, and that is the $R^2$ value we get
from both calculations:


```r
summary(model)
```

```

Call:
lm(formula = imdbRating ~ year, data = ratings)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.1000 -0.2467  0.1261  0.3880  0.7913 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)  
(Intercept) 77.13043   28.29937   2.726   0.0260 *
year        -0.03478    0.01414  -2.460   0.0393 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.6872 on 8 degrees of freedom
Multiple R-squared:  0.4306,	Adjusted R-squared:  0.3595 
F-statistic: 6.051 on 1 and 8 DF,  p-value: 0.03933
```

We can interpret $R^2$ as the fraction of the variance of
the response variable y that can be explained by the
predictor x.

## Non-linear Least Squares

So far, we only properly dealt with linear relationships
and now it is time to get non-linear.
We will be creating a mechanistically driven
predictive model, so we have a formula of which
we want to adjust the parameters so that it fits our data.

Let's take classical Michaelis-Menten-Kinetics
There is a dataset for enzyme reaction rates included in R.
But we convert it from a 
dataframe to a tibble so that it prints
nicer:


```r
puromycin <- as_tibble(Puromycin)
puromycin
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["conc"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["rate"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["state"],"name":[3],"type":["fct"],"align":["left"]}],"data":[{"1":"0.02","2":"76","3":"treated"},{"1":"0.02","2":"47","3":"treated"},{"1":"0.06","2":"97","3":"treated"},{"1":"0.06","2":"107","3":"treated"},{"1":"0.11","2":"123","3":"treated"},{"1":"0.11","2":"139","3":"treated"},{"1":"0.22","2":"159","3":"treated"},{"1":"0.22","2":"152","3":"treated"},{"1":"0.56","2":"191","3":"treated"},{"1":"0.56","2":"201","3":"treated"},{"1":"1.10","2":"207","3":"treated"},{"1":"1.10","2":"200","3":"treated"},{"1":"0.02","2":"67","3":"untreated"},{"1":"0.02","2":"51","3":"untreated"},{"1":"0.06","2":"84","3":"untreated"},{"1":"0.06","2":"86","3":"untreated"},{"1":"0.11","2":"98","3":"untreated"},{"1":"0.11","2":"115","3":"untreated"},{"1":"0.22","2":"131","3":"untreated"},{"1":"0.22","2":"124","3":"untreated"},{"1":"0.56","2":"144","3":"untreated"},{"1":"0.56","2":"158","3":"untreated"},{"1":"1.10","2":"160","3":"untreated"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The initial rate $v_0$ of the an
enzymatic reaction was measured
for a control and a sample treated
with puromycin at different substrate
concentrations.
For every concentration we
have two replicates except for
one missing replicate.


```r
puromycin %>% 
  ggplot(aes(conc, rate, color = state)) +
  geom_point()
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-25-1.png" width="100%" />


From our Biochemistry studies, we know
that we can express the rate depending
on the concentration with the following
formula:

$$rate=\frac{(Vm * conc)}{(K + conc)}$$

To make it easier to work with, let's
turn it into a function.


```r
rate <- function(conc, Vm, K) {
  Vm * conc / (K + conc)
}
```

Let's pick some arbitrary starting values.
For example, we see that the maximal velocity
could be around 200.
We also know that K is the concentration at which the half-maximal
velocity is reached.


```r
puromycin %>% 
  ggplot(aes(conc, rate, color = state)) +
  geom_point() +
  geom_function(fun = ~ rate(conc = .x, Vm = 200, K = 0.2),
                color = "black")
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-27-1.png" width="100%" />

`geom_function` expects a function of x or an anonymous function
where the first argument is the values on the x-axis,
so this is what we did.
Well, I bet we can do better than guessing the function!
What R can do for us is the same it did for linear least squares
and that is minimizing the distance of our curve to the
datapoints.
This is the job of the `nls` function, which stands for
**Nonlinear Least Squares**.

### One model

Let's look at just the "treated" data first.


```r
treated <- filter(puromycin, state == "treated")
model <- nls(rate ~ rate(conc, Vm, K),
             data = treated,
             start = list(Vm = 200, K = 0.3)
             )

model
```

```
Nonlinear regression model
  model: rate ~ rate(conc, Vm, K)
   data: treated
       Vm         K 
212.68368   0.06412 
 residual sum-of-squares: 1195

Number of iterations to convergence: 7 
Achieved convergence tolerance: 3.528e-06
```

NlS needs starting values, so we use any guess that isn't too far off.
If it is completely wrong, the model doesn't know in which direction it
should move the parameters to improve the fit and we get an error like this:
`Error in nls(rate ~ rate(conc, Vm, K), data = puro, subset = state ==  : singular gradient`

> For this special case, R also has a self-starting model. I won't go
  into it because it is not as useful as the general concept of fitting
  arbitry functions, but you can check out `SSmicmen` for a model that
  estimes the starting values automatically.

Additionally, `nls` takes an argument `subset`, which works
like the `dplyr` verb `filter` so that we can fit
the model on a subset of the data without having to create it beforehand.

We use the `broom` package to display our model parameters in a tidy tibble.


```r
tidy(model)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["term"],"name":[1],"type":["chr"],"align":["left"]},{"label":["estimate"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["std.error"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["statistic"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["p.value"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"Vm","2":"212.68367732","3":"6.947151420","4":"30.614516","5":"3.241156e-11"},{"1":"K","2":"0.06412118","3":"0.008280939","4":"7.743226","5":"1.565138e-05"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

With the base-R function `predict` we can make new predictions
based on a model and new data:


```r
head(predict(model, newdata = list(conc = seq(0, 1, 0.01))))
```

```
[1]  0.00000 28.69405 50.56602 67.79038 81.70621 93.18326
```

We can use the same function inside of `geom_function`:


```r
treated %>% 
  ggplot(aes(conc, rate, color = state)) +
  geom_point() +
  geom_function(fun = ~ predict(model, newdata = list(conc = .x)),
                color = "black")
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-31-1.png" width="100%" />

Or alternatively create a new dataset of predictions
beforehand and use that with `geom_line`:


```r
predictions <- tibble(
  conc = seq(0, 1, 0.01),
  rate = predict(model, newdata = list(conc = conc))
)

treated %>% 
  ggplot(aes(conc, rate, color = state)) +
  geom_point() +
  geom_line(data = predictions, color = "black")
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-32-1.png" width="100%" />


```r
augment(model) %>% 
  ggplot(aes(conc, .resid)) +
  geom_point()
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-33-1.png" width="100%" />

### Multiple models

Now, what if we want to fit the model for both states?
We can resort back to our trusty `purrr` package like
we did in an earlier lecture.

We start out by creating a function that takes
a dataframe and fits our model:


```r
fit_micmen <- function(data) {
  nls(rate ~ rate(conc, Vm, K),
      data = data,
      start = list(Vm = 200, K = 0.3)
  ) 
}
```

And by nesting the data (grouped by state)
into a list column we can map
this function over each dataset.
And to get the fitted parameters
we map the `tidy` function from `broom`
over the fitted models.


```r
models <- puromycin %>% 
  group_by(state) %>% 
  nest() %>% 
  mutate(
    model = map(data, fit_micmen),
    params = map(model, tidy)
  )
```

Let's inspect the fitted parameters.


```r
models %>% 
  select(state, params) %>% 
  unnest(params) %>% 
  select(state, term, estimate) %>% 
  pivot_wider(names_from = term, values_from = estimate)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["state"],"name":[1],"type":["fct"],"align":["left"]},{"label":["Vm"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["K"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"treated","2":"212.6837","3":"0.06412118"},{"1":"untreated","2":"160.2800","3":"0.04770814"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

To plot our fitted models we have two options.
Firstly, we could generate the predicted values
for a number of concentrations beforehand
and then plot these:


```r
make_predicions <- function(model) {
  tibble(
    conc = seq(0, 1.2, 0.01),
    rate = predict(model, newdata = list(conc = conc))
  )
}

predictions <- models %>% 
  mutate(
    preds = map(model, make_predicions)
  ) %>% 
  select(state, preds) %>% 
  unnest(preds)

puromycin %>% 
  ggplot(aes(conc, rate, color = state)) +
  geom_point() +
  geom_line(data = predictions)
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-37-1.png" width="100%" />

Or we use `geom_smooth`, which can take "nls" as a method as well.
We just need to make sure to pass the correct arguments.
And it can be confusing, because when we are specifying
the formula in `geom_smooth`, it always needs to be 
a formula of `y ~ x`, whereas in the normal `nls` we did
earlier, we specified the variables in terms of their
actual names (`rate` and `conc`).


```r
puromycin %>% 
  ggplot(aes(conc, rate, color = state)) +
  geom_point() +
  geom_smooth(method = "nls",
              formula = y ~ rate(conc = x, Vm, K),
              method.args = list(start = list(Vm = 200, K = 0.3)),
              se = FALSE
              )
```

<img src="07-fallacies_files/figure-html/unnamed-chunk-38-1.png" width="100%" />

We also need `se = FALSE`, because by default R would
try to plot a confidence interval around the fit-line
like it did for the linear model, but `nls` doesn't return one,
so we would get an error.

The unfortunate thing about this method is that we end up
fitting the model twice, once to get the estimated parameters
and the likes for ourselves and a second time in ggplot
to display the fitted lines. But in most cases this is not
a problem, because the model is not very computationally expensive.

### Excursion: A weird error message

Finally, I want to take minute to mention another approach
which we took earlier in the series when we where fitting
many linear models and show you, why it unfortunately
does not work here.


```r
newmodels <- puromycin %>% 
  group_by(state) %>% 
  summarise(
    model = list(nls(rate ~ rate(conc, Vm, K),
                start = list(Vm = 200, K = 0.3))
    )
  )
```

At first it looks like everything is fine.
Because we are inside of a dplyr verb `nls` know
where to look for the columns `rate` and `conc` that it should
fit, so we are not specifying its `data` argument.
However, this fails in an unexpected way when we later try
to make predictions with one of the models:


```r
make_predicions(newmodels$model[[1]])
```

```
Error: Obsolete data mask.
x Too late to resolve `rate` after the end of `dplyr::summarise()`.
ℹ Did you save an object that uses `rate` lazily in a column in the `dplyr::summarise()` expression ?
```

The reason for this as follows:
When `nls` fit the model it didn't remember the actual values
of `rate` and `conc`, it just made a note that these are columns
available in the data.
And because the data was not passed to it explicitly it
just wrote down that the columns are available in the
environment in which it was called, which at that
time was inside of `summarise`.
Check out the `data` argument here:


```r
newmodels$model[[1]]
```

```
Nonlinear regression model
  model: rate ~ rate(conc, Vm, K)
   data: parent.frame()
       Vm         K 
212.68368   0.06412 
 residual sum-of-squares: 1195

Number of iterations to convergence: 7 
Achieved convergence tolerance: 3.528e-06
```

It just says `parent.frame`, meaning "the environment around me".
But once it has left the context of `summarise`,
this is no longer available, so it can't find the `rate` column.
This is why is is always safer to pass the data
explicitly like we did in the approach that worked.

## Exercises

### The Datasaurus Dozen

The Datasaurus Dozen [@matejka2017] is a dataset
crafted to illustrate certain concepts.
It can be accessed from R via the `datasauRus` package.


```r
datasauRus::datasaurus_dozen
```

- Explore the dataset before looking at the publication
  above (it contains spoilers...):
  - It actually contains 13 different datasets,
    denoted by the column `dataset`, in one tibble.
    What are the means for x and y for the different datasets?
    What are the standard deviations for x and y for the different datasets?
    What are the correlations coefficients for the different datasets?
    I bet you notice a pattern by now.
  - Now create one (or multiple) scatterplots of the data.
    What do you notice? what conclusions do you draw from this observation?
    
There is another dataset in the package to illustrate a different
point:


```r
datasauRus::box_plots
```

- First, turn it into a tidy format, much like the `datasaurus_dozen`
  tibble.
- Now, visualize the distributions of the values for the
  5 different groups. Try out different versions of your plot
  until you are satisfied, but be sure to also include a boxplot
  and compare it to your approaches.
  What do you find?

### Fit a non-linear model

I found this gloriously 2000s website for "Statistical Reference Datasets":
<https://www.itl.nist.gov/div898/strd/index.html>
by the Information Technology Laboratory.
Not only has this official website of the United Stats Government
amazing unapologetic Word-Art,
it also features some handy datasets to
practice fitting non-linear models (<https://itl.nist.gov/div898/strd/nls/nls_main.shtml>)!

Of these I chose one for you to explore:
<https://itl.nist.gov/div898/strd/nls/data/LINKS/DATA/Chwirut2.dat>

Because you might come across some challenges, I am leaving 
some tips below, hidden behind `details` panels,
so you can choose if and when you need them:

<details>
<summary>
Tip 1
</summary>
You can read in data that is separated by whitespace with `readr`s function
`read_table`.
</details>

<details>
<summary>
Tip 2
</summary>
You have to skip the first 60 lines and set column names manually.
</details>


<details>
<summary>
Tip 3
</summary>
The description in the dataset header also contains
the function to fit and potential starting values to try out.
Note, the `e` in the function refers to the remaining
error of the fit, so you don't need it in your function.
</details>


