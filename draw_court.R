#citation: we pulled and edited code from: https://gist.github.com/edkupfer/6259635
#original code drew a full court, we only wanted half court to plot shots


library(lattice)

xyplot(NA~NA,ylab='',xlab='',aspect='iso',xlim=c(-25,25),ylim=c(-47,47),
       ### remove outside box and ticks, there must be a better way:
       par.settings = list(axis.line = list(col = "transparent")), par.box = c(col = "transparent"),
       scales=list(draw=F),
       panel=function(...){
         #outside box:
         panel.lines(x=c(-25,-25,25,25,-25),y=c(-47,47,47,-47,-47))
         #halfcourt line
         panel.lines(x=c(-25,25),y=c(0,0))
         #solid FT semicircle above FT line:
         panel.lines(x=c(-6000:(-1)/1000,1:6000/1000),y=c(-28+sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2)))
         panel.lines(x=c(-6000:(-1)/1000,1:6000/1000),y=c(28-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2)))
         #dashed FT semicircle below FT line:
         panel.lines(x=c(-6000:(-1)/1000,1:6000/1000),y=c(-28-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2)),lty=2)
         panel.lines(x=c(-6000:(-1)/1000,1:6000/1000),y=c(28+sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2)),lty=2)
         #key:
         panel.lines(x=c(-8,-8,8,8,-8),y=c(-47,-28,-28,-47,-47))
         panel.lines(x=c(-8,-8,8,8,-8),y=c(47,28,28,47,47))
         #box inside the key:
         panel.lines(x=c(-6,-6,6,6,-6),y=c(-47,-28,-28,-47,-47))
         panel.lines(x=c(-6,-6,6,6,-6),y=c(47,28,28,47,47))
         # restricted area semicircle:
         panel.lines(x=c(-47000:(-1)/1000,1:4000/1000),y=c(1.25+sqrt(4^2-c(-47000:(-1)/1000,1:4000/1000)^2))-43)
         panel.lines(x=c(-47000:(-1)/1000,1:4000/1000),y=c(1.25-sqrt(4^2-c(-47000:(-1)/1000,1:4000/1000)^2))+40.5)
         # halfcourt semicircle:
         panel.lines(x=c(-6000:(-1)/1000,1:6000/1000),y=c(-sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2)))
         panel.lines(x=c(-6000:(-1)/1000,1:6000/1000),y=c(sqrt(6^2-c(-6000:(-1)/1000,1:6000/1000)^2)))
         # rim:
         panel.rect(-5/24,-43,5/24,54/12-47)
         panel.rect(-5/24,43,5/24,47-54/12)
         panel.lines(x=c(-750:(-1)/1000,1:750/1000,750:1/1000,-1:-750/1000),y=c(c(1.25+sqrt(0.75^2-c(-750:(-1)/1000,1:750/1000)^2)),c(1.25-sqrt(0.75^2-c(750:1/1000,-1:-750/1000)^2)))-43)
         panel.lines(x=c(-750:(-1)/1000,1:750/1000,750:1/1000,-1:-750/1000),y=c(c(1.25-sqrt(0.75^2-c(-750:(-1)/1000,1:750/1000)^2)),c(1.25+sqrt(0.75^2-c(750:1/1000,-1:-750/1000)^2)))+40.5)
         #backboard:
         panel.lines(x=c(-3,3),y=c(-43,-43))
         panel.lines(x=c(-3,3),y=c(43,43))
         #three-point line:
         panel.lines(x=c(-22,-22,-22000:(-1)/1000,1:22000/1000,22,22),y=c(-43,169/12-43,1.25+sqrt(23.75^2-c(-22000:(-1)/1000,1:22000/1000)^2),169/12-43,-43)-43)
         panel.lines(x=c(-22,-22,-22000:(-1)/1000,1:22000/1000,22,22),y=c(43,169/12+43,1.25-sqrt(23.75^2-c(-22000:(-1)/1000,1:22000/1000)^2),169/12+43,43)+43)
       })


