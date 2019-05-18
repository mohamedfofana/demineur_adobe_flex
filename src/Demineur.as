// ActionScript file
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.controls.Alert;
import mx.controls.Button;
import mx.events.MenuEvent;


const MIN_MASK:String = "00";
const SEC_MASK:String = "00";
const TIMER_INTERVAL:int = 10;
var baseTimer:int;
var t:Timer;

var map:Array;
var lX:int = 7;
var lY:int = 13;
var nbBombs:int = lY + 2;

function initTimer():void {
     t = new Timer(TIMER_INTERVAL);
     t.addEventListener(TimerEvent.TIMER, updateTimer);
}
function updateTimer(evt:TimerEvent):void {
   var d:Date = new Date(getTimer() - baseTimer);
   var min:String = (MIN_MASK + d.minutes).substr(-MIN_MASK.length);
   var sec:String = (SEC_MASK + d.seconds).substr(-SEC_MASK.length);
   counter.text = String(min + ":" + sec);
}

 function startTimer():void {
	play.setStyle("icon",startIcon);
	play.setStyle('skin', null);
  	baseTimer = getTimer();
  	t.start();
}

function stopTimer():void {
	play.setStyle("icon",stopIcon);
   	t.stop();
}
 function createMap():void{	
	map = new Array();
	for (var i:int = 0; i < 13; i++)
	{
		map[i] = new Array();
		for (var j:int = 0; j<7; j++){
			var b:Button = new Button();
			b.id = i + "," + j;
			b.name = i + "," + j;		
			b.x = 8.5 + j * 50;
			b.y = 40 + i * 30;
			b.height = 30;
			b.width	= 50;
			b.addEventListener(MouseEvent.CLICK, checkIfButtonHasBomb);
			map[i][j] = b; 		    
		    addChild(b);
	 	}
	}
	/* Alert.show(Button(map[0][2]).label + " " + "Hello World !!!"); */
} 

function reInit():void{
	for (var i:int = 0; i < 13; i++)
	{
		for (var j:int = 0; j<7; j++){			
			Button(map[i][j]).label = "";
		    Button(map[i][j]).enabled = true;
	 	}
	}	
	setBombs();
    setNbBombsNear();
    //Timer
//    counter.text = "00:00";
    startTimer();
}

 function init():void
{   
	this.setStyle("skinClass",minefield);
	play.addEventListener(MouseEvent.CLICK, chooseIcon);
	createMap();
    setBombs();
    setNbBombsNear();
    initTimer();
    startTimer();
}
function chooseIcon():void{
	if (counter.text ="00:00")
		startTimer();
	else
		stopTimer();
}
 function centerWidget():void
{
 /*    QDesktopWidget* desktop = QApplication::desktop();
    int screenWidth, width;
    int screenHeight, height;
    int x, y;
    QSize windowSize;

    screenWidth = desktop->width(); // get width of screen
    screenHeight = desktop->height(); // get height of screen

    windowSize = size(); // size of our application window
    width = windowSize.width();
    height = windowSize.height();

    // little computations
    x = (screenWidth - width) / 2;
    y = (screenHeight - height) / 2;
    y -= 50;

    // move window to desired coordinates
    move ( x, y ); */
}
 function randInt(min:Number, max:Number):int
{
    // Random number between low and high
	  return Math.floor(Math.random() * (max + 1 - min)); 
     //return Math.floor(Math.random() * max); 
}

 function setBombs():void
{
    /*  QTime time = QTime::currentTime();
    qsrand((uint)time.msec()); */    
    var compt:int = 0; 
    var i:int = 0;
    while (i < nbBombs)
    {
        var text:String;
        var x:int, y:int;
        x = randInt(0, lY-1);
        y = randInt(0, lX-1);
        if (x < lY && y < lX){
	        Button(map[x][y]).name = "b";
	        //Button(map[x][y]).label = "b";
	        compt++;
        }
        i++;
    } 
    
}

 function setNbBombsNear():void
{
     for(var i:int = 0; i < lY; i++)
       for(var j:int = 0; j < lX; j++)
        {
           var compt:int = 0;
           if (Button(map[i][j]).name != "b")
           {
               for(var k:int = -1; k < 2; k++)
                  for(var l:int = -1; l <2; l++)
                      if (checkBombs(i+k,j+l) == true)
                          compt++;
               if (compt == 0)
                   Button(map[i][j]).name = i + "," + j;
               else{
                   Button(map[i][j]).name = ""+compt;
                   Button(map[i][j]).setStyle("fontColor", "red");
               }
           }
        } 
}

 function setNbBombsNearButton(i:int, j:int):void
{
 	Button(map[i][j]).label = Button (map[i][j]).name;
    /* var compt:int = 0;
    if (Button (map[i][j]).name != "b")
       {
               for(var k:int = -1; k < 2; k++)
                  for(var l:int = -1; l <2; l++)
                      if (checkBombs(i+k,j+l) == true)
                          compt++;
               Button(map[i][j]).label = "" + compt;
       } */
 
}

 function checkBombs(i:int, j:int):Boolean
{
    if (i>=0 && i < lY)
        if(j>=0 && j < lX)
            if (Button (map[i][j]).name == "b")
                return true; 
    return false;
}
 function checkIfButtonHasBomb(e:MouseEvent):void
{
    
	var buttonCasted:Button = e.currentTarget as Button;
       // On teste la r�ussite du cast avant de proc�der � un quelconque acc�s dessus !
    if(buttonCasted) //emetteurCasted vaut 0 si le cast � �chou�
       {
        if (buttonCasted.name == "b")
        {
            gameOver();
        }
        else
            {
                var coord:Array = buttonCasted.name.split(",");
                if (coord.length == 1)
                    buttonCasted.label = buttonCasted.name;
                else
                {
                    var coord:Array = buttonCasted.name.split(",");
                    var i:int = coord[0];
                    var j:int = coord[1];
                    clearAroundRecur(i, j);
                }
                buttonCasted.enabled = false;
            }
       } 
}

 function gameOver():void
{
	stopTimer();
    Alert.show("Game Over!!");
     for(var i:int = 0; i < lY; i++)
       for(var j:int = 0; j < lX; j++)
        {
         if (map[i][j].name == "b" )
         {
             Button(map[i][j]).setStyle("icon",mineIcon);
         }
         else
             if (!isNaN(Number(Button(map[i][j]).name)))
                Button (map[i][j]).label = Button(map[i][j]).name;
         Button(map[i][j]).enabled = false;
        }
}

 function clearAround(i:int, j:int):void
{
             for(var k:int = -1; k < 2; k++)
               for(var l:int = -1; l <2; l++)
                   if (i+k>=0 && i+k < lX)
                       if(j+l>=0 && j+l < lY)
                            if (Button (map[i+k][j+l]).name != "b")
                            {
                                if (Button (map[i+k][j+l]).name.split(",").length == 1)
                                    Button(map[i+k][j+l]).label = Button(map[i+k][j+l]).name;
                                Button(map[i+k][j+l]).enabled = false;
                            } 
}

/**
 * Pour chaque case autour faire
 * 	Si la ces ne contient pas de bombe et n'a pas une bombe dans ses contour
 * clearAround(i,j) // fonction récursif 
 * 
 * 
 * */
 function clearAroundRecur(i:int, j:int):void
{
	if (i<0 || i>=lY || j<0 || j>=lX)
		; 
	else  if( Button(map[i][j]).id == "visited")
		;
	else if (Button(map[i][j]).name == "b")
		;
 	else if (!isNaN(Number(Button(map[i][j]).name))){
		 	Button (map[i][j]).label = Button(map[i][j]).name;
		 	Button (map[i][j]).enabled = false;
	 		;
	}
	else {			 	
	            
		Button (map[i][j]).enabled = false;
		Button (map[i][j]).id = "visited"; 
	    clearAroundRecur(i+1, j-1);
	   	clearAroundRecur(i+1, j);
	    clearAroundRecur(i+1, j+1);
	    clearAroundRecur(i-1, j-1);
	    clearAroundRecur(i-1, j);
	    clearAroundRecur(i-1, j+1);
	             
	    clearAroundRecur(i, j+1);
	    clearAroundRecur(i, j-1);
		 	
	}
}
function getCoord(b:Button):Array{
	var coord:Array = new Array();
	coord[0] = int(b.name.split(",")[0]);
	coord[1] = int(b.name.split(",")[1]);
	return coord;
}
 function afficherMessage():void
{
	Alert.show("Hello World !!!");
}

/**

* Event handler for the MenuBar control's itemClick event.

*

*/

function menuBarItemClickHandler(event:MenuEvent):void

{

	switch(event.label)
	
	{
	
		case 'Nouveau':
		
			reInit();
		
			break;
		
		case 'Meilleurs scores':
		
			trace("menuBarItemClickHandler: Meilleurs scores clicked");
		
			break;
		
		case 'Quitter':
		
			this.exit();
		
			break;
		
		default:
		
			trace("menuBarItemClickHandler: " + event.label + " clicked");
		
			break;
	
	}

}

/**

* Event handler for the MenuBar control's click event.  MouseEvent

* is useless for detecting what the user clicked on.  So, use

* the menuBar's selected index to find the label.

*

*/

function menuBarClickHandler(event:MouseEvent):void
{
	try{
		if(mMenuBar.selectedIndex >= 0){
			var lLabel:String = mMenuBar.dataProvider[mMenuBar.selectedIndex].@label;
			switch(lLabel){
				case 'Jeu':
					trace("menuBarClickHandler: Jeu clicked");
					break;
				case 'Help':
					trace("menuBarClickHandler: Help clicked");
					break;
				default:
					trace("menuBarClickHandler: " + lLabel + " clicked");
					break;
			}
		}
		else{
			trace("topMenu.mxml menuBarClickHandler() index out of range, mMenuBar.selectedIndex = " + mMenuBar.selectedIndex);
		}
	}
	catch(err:Error)
	{
		trace("topMenu.mxml menuBarClickHandler() EXCEPTION: " + err.toString());
	}

}