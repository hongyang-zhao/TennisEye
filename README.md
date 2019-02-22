## TennisEye Overview

TennisEye is a tennis ball speed calculation system. It is the first research publication to calculate the serve, groundstroke and volley speed of a tennis ball using a racket mounted motion sensor.


## Data Collection

The motion sensor we used is a [UG sensor](https://ubibrothers.wordpress.com/). It includes a triaxial acceleration sensor and a triaxial gyroscope. The measure range of the accelerometer and the gyroscope were set to be ± 16g and ± 2000◦/sec, respectively. Both sensors were sampled with 100 Hz. The UG sensor was fixed at the handle of the players’ rackets. Fig. 2 shows the sensor position and the coordinate system. We collected data in a tennis court that was equipped with a [PlaySight system](https://playsight.com/), which included six high definition (HD) cameras. The PlaySight system uses image processing algorithm to recognize stroke type, ball speed, and spin speed. 

We collected data from 7 players. Based on their self-report information, we divided the subjects into three categories: coach, regular player, and casual player. The coaches play several times per week, the regular players play one time per week, and the casual players play 0∼2 times per month. Table 2 shows the summary of tennis data we collected with a UG sensor. In total, we collected 569 serves, 1398 groundstrokes, and 18 volleys. The summary of the tennis dataset in shown in TableXXX.


## Data Set

new_data_all_7.mat is the tennis data set. It includes two files: all_data and all_data_label. all_data file includes the motion sensor data for each shot. all_data_label file includes the stroke types, outgoing ball speed, outgoing ball spin speed, incoming ball speed, and incoming ball spin speed for each shot. The structure of all_data file is shown in ![Fig.1](./Figures/all_data.jpg). The strucuture of all_data_label file is shown in ![Fig.2](./Figures/all_data_label.jpg).



Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/hongyang-zhao/TennisEye/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
