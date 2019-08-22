function getXmlHttpRequestObject() {
	if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		return new ActiveXObject("Microsoft.XMLHTTP");
	} else {
		alert("Your Browser Sucks!");
	}
}

//Our XmlHttpRequest object to get the auto suggest
var searchReq = getXmlHttpRequestObject();

//Called from keyup on the search textbox.
//Starts the AJAX request.
function searchSuggest() {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('PoNumber').value);
		searchReq.open("GET", 'autocomplete/getactor.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchSuggest; 
		searchReq.send(null);
	}
}


//Called when the AJAX response is returned.
function handleSearchSuggest() {
	if (searchReq.readyState == 4) {
	        var ss = document.getElementById('layer1');
		var str1 = document.getElementById('PoNumber');
		var curLeft=0;
		if (str1.offsetParent){
		    while (str1.offsetParent){
			curLeft += str1.offsetLeft;
			str1 = str1.offsetParent;
		    }
		}
		var str2 = document.getElementById('PoNumber');
		var curTop=20;
		if (str2.offsetParent){
		    while (str2.offsetParent){
			curTop += str2.offsetTop;
			str2 = str2.offsetParent;
		    }
		}
		var str =searchReq.responseText.split("\n");
		if(str.length>10 )
			{
				var cnt =10;
			}
		else
			{
				var cnt=str.length;
			}
		if(str.length==1)
		    document.getElementById('layer1').style.visibility = "hidden";
		else
		    ss.setAttribute('style','position:absolute;top:'+curTop+';left:'+curLeft+';width:200px;z-index:1;padding:5px;border: 1px solid #000000; overflow:auto; height:auto; background-color:#F5F5FF; cursor:pointer');
		ss.innerHTML = '';
		for(i=0; i < cnt - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setSearch(this.innerHTML);" ';
			suggest += 'class="small">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Mouse over function
function suggestOver(div_value) {
	div_value.className = 'suggest_link_over';
}
//Mouse out function
function suggestOut(div_value) {
	div_value.className = 'suggest_link';
}
//Click function
function setSearch(value) {
	document.getElementById('PoNumber').value = value;
	document.getElementById('layer1').innerHTML = '';
	document.getElementById('layer1').style.visibility = "hidden";
}
//////  for auto complete director///
//Starts the AJAX request.
function searchDirector() {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('director').value);
		searchReq.open("GET", 'autocomplete/getdirector.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchDirector; 
		searchReq.send(null);
	}
}


//Called when the AJAX response is returned.
function handleSearchDirector() {
	if (searchReq.readyState == 4) {
	        var ss = document.getElementById('layer2');
		var str1 = document.getElementById('director');
		var curLeft=0;
		if (str1.offsetParent){
		    while (str1.offsetParent){
			curLeft += str1.offsetLeft;
			str1 = str1.offsetParent;
		    }
		}
		var str2 = document.getElementById('director');
		var curTop=20;
		if (str2.offsetParent){
		    while (str2.offsetParent){
			curTop += str2.offsetTop;
			str2 = str2.offsetParent;
		    }
		}
		var str =searchReq.responseText.split("\n");
		if(str.length>10 )
			{
				var cnt =10;
			}
		else
			{
				var cnt=str.length;
			}
		if(str.length==1)
		    document.getElementById('layer2').style.visibility = "hidden";
		else
		    ss.setAttribute('style','position:absolute;top:'+curTop+';left:'+curLeft+';width:200px;z-index:1;padding:5px;border: 1px solid #000000; overflow:auto; height:auto; background-color:#F5F5FF; cursor:pointer');
		ss.innerHTML = '';
		for(i=0; i < cnt - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setDirector(this.innerHTML);" ';
			suggest += 'class="small">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Click function
function setDirector(value) {
	document.getElementById('director').value = value;
	document.getElementById('layer2').innerHTML = '';
	document.getElementById('layer2').style.visibility = "hidden";
}
//////  for auto complete music director///
//Starts the AJAX request.
function searchMusic() {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('music').value);
		searchReq.open("GET", 'autocomplete/getmusic.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchMusic; 
		searchReq.send(null);
	}
}


//Called when the AJAX response is returned.
function handleSearchMusic() {
	if (searchReq.readyState == 4) {
	        var ss = document.getElementById('layer3');
		var str1 = document.getElementById('music');
		var curLeft=0;
		if (str1.offsetParent){
		    while (str1.offsetParent){
			curLeft += str1.offsetLeft;
			str1 = str1.offsetParent;
		    }
		}
		var str2 = document.getElementById('music');
		var curTop=20;
		if (str2.offsetParent){
		    while (str2.offsetParent){
			curTop += str2.offsetTop;
			str2 = str2.offsetParent;
		    }
		}
		var str =searchReq.responseText.split("\n");
		if(str.length>10 )
			{
				var cnt =10;
			}
		else
			{
				var cnt=str.length;
			}
		if(str.length==1)
		    document.getElementById('layer3').style.visibility = "hidden";
		else
		    ss.setAttribute('style','position:absolute;top:'+curTop+';left:'+curLeft+';width:200px;z-index:1;padding:5px;border: 1px solid #000000; overflow:auto; height:auto; background-color:#F5F5FF; cursor:pointer');
		ss.innerHTML = '';
		for(i=0; i < cnt - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setMusic(this.innerHTML);" ';
			suggest += 'class="small">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Click function
function setMusic(value) {
	document.getElementById('music').value = value;
	document.getElementById('layer3').innerHTML = '';
	document.getElementById('layer3').style.visibility = "hidden";
}
//////  for auto complete Company director///
//Starts the AJAX request.
function searchCompany() {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('company').value);
		searchReq.open("GET", 'autocomplete/getcompany.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchCompany; 
		searchReq.send(null);
	}
}


//Called when the AJAX response is returned.
function handleSearchCompany() {
	if (searchReq.readyState == 4) {
	        var ss = document.getElementById('layer4');
		var str1 = document.getElementById('company');
		var curLeft=0;
		if (str1.offsetParent){
		    while (str1.offsetParent){
			curLeft += str1.offsetLeft;
			str1 = str1.offsetParent;
		    }
		}
		var str2 = document.getElementById('company');
		var curTop=20;
		if (str2.offsetParent){
		    while (str2.offsetParent){
			curTop += str2.offsetTop;
			str2 = str2.offsetParent;
		    }
		}
		var str =searchReq.responseText.split("\n");
		if(str.length>10 )
			{
				var cnt =10;
			}
		else
			{
				var cnt=str.length;
			}
		if(str.length==1)
		    document.getElementById('layer4').style.visibility = "hidden";
		else
		    ss.setAttribute('style','position:absolute;top:'+curTop+';left:'+curLeft+';width:200px;z-index:1;padding:5px;border: 1px solid #000000; overflow:auto; height:auto; background-color:#F5F5FF; cursor:pointer');
		ss.innerHTML = '';
		for(i=0; i < cnt - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setCompany(this.innerHTML);" ';
			suggest += 'class="small">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Click function
function setCompany(value) {
	document.getElementById('company').value = value;
	document.getElementById('layer4').innerHTML = '';
	document.getElementById('layer4').style.visibility = "hidden";
}

function searchAuthor() {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('author').value);
		searchReq.open("GET", 'autocomplete/getauthor.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchAuthor; 
		searchReq.send(null);
	}
}


//Called when the AJAX response is returned.
function handleSearchAuthor() {
	if (searchReq.readyState == 4) {
	        var ss = document.getElementById('layer1');
		var str1 = document.getElementById('author');
		var curLeft=0;
		if (str1.offsetParent){
		    while (str1.offsetParent){
			curLeft += str1.offsetLeft;
			str1 = str1.offsetParent;
		    }
		}
		var str2 = document.getElementById('author');
		var curTop=20;
		if (str2.offsetParent){
		    while (str2.offsetParent){
			curTop += str2.offsetTop;
			str2 = str2.offsetParent;
		    }
		}
		var str =searchReq.responseText.split("\n");
		if(str.length>10 )
			{
				var cnt =10;
			}
		else
			{
				var cnt=str.length;
			}
		if(str.length==1)
		    document.getElementById('layer1').style.visibility = "hidden";
		else
		    ss.setAttribute('style','position:absolute;top:'+curTop+';left:'+curLeft+';width:200px;z-index:1;padding:5px;border: 1px solid #000000; overflow:auto; height:auto; background-color:#F5F5FF; cursor:pointer');
		ss.innerHTML = '';
		for(i=0; i < cnt - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setAuthor(this.innerHTML);" ';
			suggest += 'class="small">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Click function
function setAuthor(value) {
	document.getElementById('author').value = value;
	document.getElementById('layer1').innerHTML = '';
	document.getElementById('layer1').style.visibility = "hidden";
}


function searchPublisher() {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('publisher').value);
		searchReq.open("GET", 'autocomplete/getpublisher.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchPublisher; 
		searchReq.send(null);
	}
}


//Called when the AJAX response is returned.
function handleSearchPublisher() {
	if (searchReq.readyState == 4) {
	        var ss = document.getElementById('layer4');
		var str1 = document.getElementById('publisher');
		var curLeft=0;
		if (str1.offsetParent){
		    while (str1.offsetParent){
			curLeft += str1.offsetLeft;
			str1 = str1.offsetParent;
		    }
		}
		var str2 = document.getElementById('publisher');
		var curTop=20;
		if (str2.offsetParent){
		    while (str2.offsetParent){
			curTop += str2.offsetTop;
			str2 = str2.offsetParent;
		    }
		}
		var str =searchReq.responseText.split("\n");
		if(str.length>10 )
			{
				var cnt =10;
			}
		else
			{
				var cnt=str.length;
			}
		if(str.length==1)
		    document.getElementById('layer4').style.visibility = "hidden";
		else
		    ss.setAttribute('style','position:absolute;top:'+curTop+';left:'+curLeft+';width:200px;z-index:1;padding:5px;border: 1px solid #000000; overflow:auto; height:auto; background-color:#F5F5FF; cursor:pointer');
		ss.innerHTML = '';
		for(i=0; i < cnt - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setPublisher(this.innerHTML);" ';
			suggest += 'class="small">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Click function
function setPublisher(value) {
	document.getElementById('publisher').value = value;
	document.getElementById('layer4').innerHTML = '';
	document.getElementById('layer4').style.visibility = "hidden";
}