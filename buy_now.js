function buy_nowForm() 
{
		
	/*var dvd	= document.frm_buy.dvd.value;	
	var vcd	= document.frm_buy.vcd.value;
	var blu	= document.frm_buy.blu.value;
	var acd	= document.frm_buy.acd.value;
	var mp3	= document.frm_buy.mp3.value;
	var three	= document.frm_buy.three.value;*/
	
	if(document.frm_buy.dvd.checked) { var dvd	= document.frm_buy.dvd.value; } else { var dvd=0; }
	if(document.frm_buy.vcd.checked) { var vcd	= document.frm_buy.vcd.value; } else { var vcd=0; }
	if(document.frm_buy.blu.checked) { var blu	= document.frm_buy.blu.value; } else { var blu=0; }
	if(document.frm_buy.blu3d.checked) { var blu3d	= document.frm_buy.blu3d.value; } else { var blu3d=0; }
	if(document.frm_buy.acd.checked) { var acd	= document.frm_buy.acd.value; } else { var acd=0; }
	if(document.frm_buy.mp3.checked) { var mp3	= document.frm_buy.mp3.value; } else { var mp3=0; }
	if(document.frm_buy.three.checked) { var three	= document.frm_buy.three.value; } else { var three=0; }
	if(document.frm_buy.cdrom.checked) { var cdrom	= document.frm_buy.cdrom.value; } else { var cdrom=0; }

	var dvdquantity	= document.frm_buy.dvdquantity.value;
	var vcdquantity	= document.frm_buy.vcdquantity.value;
	var bluquantity	= document.frm_buy.bluquantity.value;
	var blu3dquantity	= document.frm_buy.blu3dquantity.value;
	var acdquantity	= document.frm_buy.acdquantity.value;
	var mp3quantity	= document.frm_buy.mp3quantity.value;
	var threequantity= document.frm_buy.threequantity.value;
	var cdromquantity= document.frm_buy.cdromquantity.value;

	if(dvdquantity) { dvdquantity = dvdquantity; } else { dvdquantity =0; }
	if(vcdquantity) { vcdquantity = vcdquantity; } else { vcdquantity =0; }
	if(bluquantity) { bluquantity = bluquantity; } else { bluquantity =0; }
	if(blu3dquantity) { blu3dquantity = blu3dquantity; } else { blu3dquantity =0; }
	if(acdquantity) { acdquantity = acdquantity; } else { acdquantity =0; }
	if(mp3quantity) { mp3quantity = mp3quantity; } else { mp3quantity =0; }
	if(threequantity) { threequantity = threequantity; } else { threequantity =0; }
	if(cdromquantity) { cdromquantity = cdromquantity; } else { cdromquantity =0; }

	var dvdprice	= document.frm_buy.dvdprice.value;
	var vcdprice	= document.frm_buy.vcdprice.value;
	var bluprice	= document.frm_buy.bluprice.value
	var blu3dprice	= document.frm_buy.blu3dprice.value
	var acdprice	= document.frm_buy.acdprice.value;
	var mp3price	= document.frm_buy.mp3price.value;
	var threeprice	= document.frm_buy.threeprice.value;
	var cdromprice	= document.frm_buy.cdromprice.value;

	var mov	= document.frm_buy.mov.value;
	var str	= document.frm_buy.moviename.value;
	var moviename =  str.replace("&", "^");
	var popup		= document.frm_buy.popup.value;
	var movieyear	= document.frm_buy.year.value;

authenticate_popup(dvd,vcd,blu,blu3d,acd,mp3,three,cdrom,dvdquantity,vcdquantity,bluquantity,blu3dquantity,acdquantity,mp3quantity,threequantity,cdromquantity,dvdprice,vcdprice,bluprice,blu3dprice,acdprice,mp3price,threeprice,cdromprice,mov,moviename,popup,movieyear)
return true;
}

function thankLoad(){
	document.getElementById("added").style.display="block";
	setTimeout("formLoad()",2000);
}
function formLoad(){
	document.getElementById("added").style.display="none";
}

function getXMLHTTP() { //fuction to return the xml http object
		var xmlhttp=false;	
		try{
			xmlhttp=new XMLHttpRequest();
		}
		catch(e)	{		
			try{			
				xmlhttp= new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e){
				try{
				xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
				}
				catch(e1){
					xmlhttp=false;
				}
			}
		}
		 	
		return xmlhttp;
    }

function authenticate_popup(dvdVal,vcdVal,bluVal,blu3dVal,acdVal,mp3Val,threeVal,cdromVal,dvdquantityVal,vcdquantityVal,bluquantityVal,blu3dquantityVal,acdquantityVal,mp3quantityVal,threequantityVal,cdromquantityVal,dvdpriceVal,vcdpriceVal,blupriceVal,blu3dpriceVal,acdpriceVal,mp3priceVal,threepriceVal,cdrompriceVal,movVal,movienameVal,popupVal,movieyearVal)	 {
/*
var strURL="http://www.explorecommunity.com/myindiashopping/buy_now_action.php?dvd="+dvdVal+"&vcd="+vcdVal+"&blu="+bluVal+"&acd="+acdVal+"&mp3="+mp3Val+"&three="+threeVal+"&cdrom="+cdromVal+"&dvdquantity="+dvdquantityVal+"&vcdquantity="+vcdquantityVal+"&bluquantity="+bluquantityVal+"&acdquantity="+acdquantityVal+"&mp3quantity="+mp3quantityVal+"&threequantity="+threequantityVal+"&cdromquantity="+cdromquantityVal+"&dvdprice="+dvdpriceVal+"&vcdprice="+vcdpriceVal+"&bluprice="+blupriceVal+"&acdprice="+acdpriceVal+"&mp3price="+mp3priceVal+"&threeprice="+threepriceVal+"&cdromprice="+cdrompriceVal+"&mov="+movVal+"&moviename="+movienameVal+"&popup="+popupVal+"&year="+movieyearVal;
*/
//
var strURL="buy_now_action.php?dvd="+dvdVal+"&vcd="+vcdVal+"&blu="+bluVal+"&blu3d="+blu3dVal+"&acd="+acdVal+"&mp3="+mp3Val+"&three="+threeVal+"&cdrom="+cdromVal+"&dvdquantity="+dvdquantityVal+"&vcdquantity="+vcdquantityVal+"&bluquantity="+bluquantityVal+"&blu3dquantity="+blu3dquantityVal+"&acdquantity="+acdquantityVal+"&mp3quantity="+mp3quantityVal+"&threequantity="+threequantityVal+"&cdromquantity="+cdromquantityVal+"&dvdprice="+dvdpriceVal+"&vcdprice="+vcdpriceVal+"&bluprice="+blupriceVal+"&blu3dprice="+blu3dpriceVal+"&acdprice="+acdpriceVal+"&mp3price="+mp3priceVal+"&threeprice="+threepriceVal+"&cdromprice="+cdrompriceVal+"&mov="+movVal+"&moviename="+movienameVal+"&popup="+popupVal+"&year="+movieyearVal;
/*
var strURL="http://www.explorecommunity.com/myindiashopping/buy_now_action.php?dvd="+dvdVal+"&vcd="+vcdVal+"&blu="+bluVal+"&acd="+acdVal+"&mp3="+mp3Val+"&three="+threeVal+"&cdrom="+cdromVal+"&dvdquantity="+dvdquantityVal+"&vcdquantity="+vcdquantityVal+"&bluquantity="+bluquantityVal+"&acdquantity="+acdquantityVal+"&mp3quantity="+mp3quantityVal+"&threequantity="+threequantityVal+"&cdromquantity="+cdromquantityVal+"&dvdprice="+dvdpriceVal+"&vcdprice="+vcdpriceVal+"&bluprice="+blupriceVal+"&acdprice="+acdpriceVal+"&mp3price="+mp3priceVal+"&threeprice="+threepriceVal+"&cdromprice="+cdrompriceVal+"&mov="+movVal+"&moviename="+movienameVal+"&popup="+popupVal+"&year="+movieyearVal;
*/
		var req = getXMLHTTP();
		//alert(thisVal1)
			if (req) {
				//document.getElementById('listClientDetails').style.display='block';
				req.onreadystatechange = function() {
					if (req.readyState == 4) {
						// only if "OK"
						if (req.status == 200) {	
						 	//if(req.responseText.match(/^OK/) != null) {
							if(req.responseText!= null) {
								var response = req.responseText.split("|");
        					// alert('Your message has been sent!');  
							document.getElementById("popup_reload").innerHTML= response[1];
							document.getElementById("reply").innerHTML= response[0];
        					 thankLoad();
							 
        					}
														
						} else {
							alert("There was a problem while using XMLHTTP:\n" + req.statusText);
						}
					}				
				}			
				req.open("POST", strURL, true);
				//req.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
				req.send(null);
			}			
		
	} 