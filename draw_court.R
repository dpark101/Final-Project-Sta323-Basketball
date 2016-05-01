#https://gist.github.com/edkupfer/6354404
library(ggplot2)

ggplot(shots, aes(x=loc_x, y=loc_y)) + 
  #outer borders
  geom_path(data=data.frame(x=c(25,-25,-25,25,25),y=c(0,0,47,47,0)),aes(x=x,y=y)) +
  #top freethrow semicircle
  geom_path(data=data.frame(x=c(-6000:(-1)/1000,1:6000/1000),y=c(19+sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2))),aes(x=x,y=y))+
  #bottom freethrow semicircle
  geom_path(data=data.frame(x=c(-6000:(-1)/1000,1:6000/1000),y=c(19-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2))),aes(x=x,y=y),linetype='dashed')+
  #key
  geom_path(data=data.frame(x=c(-8,-8,8,8,-8),y=c(0,19,19,0,0)),aes(x=x,y=y))+
  #box inside key
  geom_path(data=data.frame(x=c(-6,-6,6,6,-6),y=c(0,19,19,0,0)),aes(x=x,y=y))+
  #restricted area semicircle
  geom_path(data=data.frame(x=c(-4000:(-1)/1000,1:4000/1000),y=c(5.25+sqrt(4^2-c(-4000:(-1)/1000,1:4000/1000)^2))),aes(x=x,y=y))+
  #halfcourt semicircle
  geom_path(data=data.frame(x=c(-6000:(-1)/1000,1:6000/1000),y=c(47-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2))),aes(x=x,y=y))+
  #rim
  geom_path(data=data.frame(x=c(-750:(-1)/1000,1:750/1000,750:1/1000,-1:-750/1000),y=c(c(5.25+sqrt(0.75^2-c(-750:(-1)/1000,1:750/1000)^2)),c(5.25-sqrt(0.75^2-c(750:1/1000,-1:-750/1000)^2)))),aes(x=x,y=y))+
  #backboard
  geom_path(data=data.frame(x=c(-3,3),y=c(4,4)),aes(x=x,y=y),lineend='butt')+
  #3 pt. line
  geom_path(data=data.frame(x=c(-22,-22,-22000:(-1)/1000,1:22000/1000,22,22),y=c(0,169/12,5.25+sqrt(23.75^2-c(-22000:(-1)/1000,1:22000/1000)^2),169/12,0)),aes(x=x,y=y))+
  #shot type identifier based on color and shape
  geom_point(aes(colour = shot_zone_basic, shape = event_type)) +
  xlim(-25, 25) +
  ylim(-5, 47)

#JPEG overlay method, faster but less accurate...
#library(grid)
#library(jpeg)
#library(RCurl)
#
#points(shots$loc_x, shots$loc_y, pch =".")
##code from https://thedatagame.com.au/2015/09/27/how-to-create-nba-shot-charts-in-r/
#courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
#court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
#                    width=unit(1,"npc"), height=unit(1,"npc"))
#ggplot(shots, aes(x=loc_x, y=loc_y)) + 
#  annotation_custom(court, -25, 25, -5, 42) +
#  geom_point(aes(colour = shot_zone_basic, shape = event_type)) +
#  xlim(-25, 25) +
#  ylim(-5, 42)