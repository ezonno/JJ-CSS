/*

 MyFonts Webfont Build ID 2708775, 2013-12-16T04:41:42-0500

 The fonts listed in this notice are subject to the End User License
 Agreement(s) entered into by the website owner. All other parties are 
 explicitly restricted from using the Licensed Webfonts(s).

 You may obtain a valid license at the URLs below.

 Webfont: PF Din Mono Medium by Parachute
 URL: http://www.myfonts.com/fonts/parachute/pf-din-mono/medium/
 Copyright: Copyright (c) 2010 Parachute&#x00A8;, www.parachute.gr.  All rights reserved.
 Licensed pageviews: 15,000,000

 Webfont: PF Din Mono Regular by Parachute
 URL: http://www.myfonts.com/fonts/parachute/pf-din-mono/regular/
 Copyright: Copyright (c) 2010 Parachute&#x00A8;, www.parachute.gr.  All rights reserved.
 Licensed pageviews: 15,000,000

 Webfont: PF Din Mono Bold by Parachute
 URL: http://www.myfonts.com/fonts/parachute/pf-din-mono/bold/
 Copyright: Copyright (c) 2010 Parachute&#x00A8;, www.parachute.gr.  All rights reserved.
 Licensed pageviews: 15,000,000

 Webfont: Avenir 55 Roman by Linotype
 URL: http://www.myfonts.com/fonts/linotype/avenir/55-roman/
 Copyright: Copyright &#x00A9; 1989, 1995, 2002 Adobe Systems Incorporated.  All Rights Reserved. &#x00A9; 1981, 1995, 2002 Heidelberger Druckmaschinen AG. All rights reserved.
 Licensed pageviews: 2,500,000

 Webfont: Avenir 35 Light by Linotype
 URL: http://www.myfonts.com/fonts/linotype/avenir/35-light/
 Copyright: Part of the digitally encoded machine readable outline data for producing the Typefaces provided is copyrighted &#x00A9; 1981 - 2007 Linotype GmbH, www.linotype.com. All rights reserved. This software is the property of Linotype GmbH, and may not be repro
 Licensed pageviews: 2,500,000

 Webfont: Avenir 85 Heavy by Linotype
 URL: http://www.myfonts.com/fonts/linotype/avenir/85-heavy/
 Copyright: Part of the digitally encoded machine readable outline data for producing the Typefaces provided is copyrighted &#x00A9; 1981 - 2007 Linotype GmbH, www.linotype.com. All rights reserved. This software is the property of Linotype GmbH, and may not be repro
 Licensed pageviews: 5,000,000

 Webfont: Gill Sans Std Roman by Monotype 
 URL: http://www.myfonts.com/fonts/mti/gill-sans/std-roman/
 Copyright: Font software Copyright 2001 Adobe Systems Incorporated. Typeface designs Copyright The Monotype Corporation. All Rights Reserved.
 Licensed pageviews: 8,000,000

 Webfont: Gill Sans Std Book by Monotype 
 URL: http://www.myfonts.com/fonts/mti/gill-sans/std-book/
 Copyright: Font software Copyright 1990, 1991, 1998 Adobe Systems Incorporated. Typeface designs Copyright The Monotype Corporation. All rights reserved.
 Licensed pageviews: 8,000,000


 License: http://www.myfonts.com/viewlicense?type=web&buildid=2708775

 ? 2013 MyFonts Inc
*/
var protocol=document.location.protocol;"https:"!=protocol&&(protocol="http:");var count=document.createElement("script");count.type="text/javascript";count.async=!0;count.src=protocol+"//hello.myfonts.net/count/295527";var s=document.getElementsByTagName("script")[0];s.parentNode.insertBefore(count,s);var browserName,browserVersion,webfontType;if("undefined"==typeof woffEnabled)var woffEnabled=!0;var svgEnabled=0;
if("undefined"!=typeof customPath)var path=customPath;else{var scripts=document.getElementsByTagName("SCRIPT"),script=scripts[scripts.length-1].src;script.match("://")||"/"==script.charAt(0)||(script="./"+script);path=script.replace(/\\/g,"/").replace(/\/[^\/]*\/?$/,"")}
var wfpath=path+"/webfonts/",browsers=[{regex:"MSIE (\\d+\\.\\d+)",versionRegex:"new Number(RegExp.$1)",type:[{version:9,type:"woff"},{version:5,type:"eot"}]},{regex:"Trident/(\\d+\\.\\d+); (.+)?rv:(\\d+\\.\\d+)",versionRegex:"new Number(RegExp.$3)",type:[{version:11,type:"woff"}]},{regex:"Firefox[/s](\\d+\\.\\d+)",versionRegex:"new Number(RegExp.$1)",type:[{version:3.6,type:"woff"},{version:3.5,type:"ttf"}]},{regex:"Chrome/(\\d+\\.\\d+)",versionRegex:"new Number(RegExp.$1)",type:[{version:6,type:"woff"},
{version:4,type:"ttf"}]},{regex:"Mozilla.*Android (\\d+\\.\\d+).*AppleWebKit.*Safari",versionRegex:"new Number(RegExp.$1)",type:[{version:4.1,type:"woff"},{version:3.1,type:"svg#wf"},{version:2.2,type:"ttf"}]},{regex:"Mozilla.*(iPhone|iPad).* OS (\\d+)_(\\d+).* AppleWebKit.*Safari",versionRegex:"new Number(RegExp.$2) + (new Number(RegExp.$3) / 10)",unhinted:!0,type:[{version:5,type:"woff"},{version:4.2,type:"ttf"},{version:1,type:"svg#wf"}]},{regex:"Mozilla.*(iPhone|iPad|BlackBerry).*AppleWebKit.*Safari",
versionRegex:"1.0",type:[{version:1,type:"svg#wf"}]},{regex:"Version/(\\d+\\.\\d+)(\\.\\d+)? Safari/(\\d+\\.\\d+)",versionRegex:"new Number(RegExp.$1)",type:[{version:5.1,type:"woff"},{version:3.1,type:"ttf"}]},{regex:"Opera/(\\d+\\.\\d+)(.+)Version/(\\d+\\.\\d+)(\\.\\d+)?",versionRegex:"new Number(RegExp.$3)",type:[{version:11.1,type:"woff"},{version:10.1,type:"ttf"}]}],browLen=browsers.length,suffix="",i=0;
a:for(;i<browLen;i++){var regex=RegExp(browsers[i].regex);if(regex.test(navigator.userAgent)){browserVersion=eval(browsers[i].versionRegex);var typeLen=browsers[i].type.length;for(j=0;j<typeLen;j++)if(browserVersion>=browsers[i].type[j].version&&(!0==browsers[i].unhinted&&(suffix="_unhinted"),webfontType=browsers[i].type[j].type,"woff"!=webfontType||woffEnabled)&&("svg#wf"!=webfontType||svgEnabled))break a}else webfontType="woff"}
/(Macintosh|Android)/.test(navigator.userAgent)&&"svg#wf"!=webfontType&&(suffix="_unhinted");var head=document.getElementsByTagName("head")[0],stylesheet=document.createElement("style");stylesheet.setAttribute("type","text/css");head.appendChild(stylesheet);
for(var fonts=[{fontFamily:"PFDinMono-Medium",url:wfpath+"295527_0"+suffix+"_0."+webfontType},{fontFamily:"PFDinMono-Regular",url:wfpath+"295527_1"+suffix+"_0."+webfontType},{fontFamily:"PFDinMono-Bold",url:wfpath+"295527_2"+suffix+"_0."+webfontType},{fontFamily:"AvenirLTStd-Roman",url:wfpath+"295527_3"+suffix+"_0."+webfontType},{fontFamily:"AvenirLT-Light",url:wfpath+"295527_4"+suffix+"_0."+webfontType},{fontFamily:"AvenirLT-Heavy",url:wfpath+"295527_5"+suffix+"_0."+webfontType},{fontFamily:"GillSansMTStd-Medium",
url:wfpath+"295527_6"+suffix+"_0."+webfontType},{fontFamily:"GillSansMTStd-Book",url:wfpath+"295527_7"+suffix+"_0."+webfontType}],len=fonts.length,css="",i=0;i<len;i++){var format="svg#wf"==webfontType?'format("svg")':"ttf"==webfontType?'format("truetype")':"eot"==webfontType?"":'format("'+webfontType+'")',css=css+("@font-face{font-family: "+fonts[i].fontFamily+";src:url("+fonts[i].url+")"+format+";");fonts[i].fontWeight&&(css+="font-weight: "+fonts[i].fontWeight+";");fonts[i].fontStyle&&(css+="font-style: "+
fonts[i].fontStyle+";");css+="}"}stylesheet.styleSheet?stylesheet.styleSheet.cssText=css:stylesheet.innerHTML=css;
