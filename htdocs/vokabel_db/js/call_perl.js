
$( document ).ready(function() {

	/*
	/* TODOs
	* 1. send UTF8
	* $.ajax({
	*		url: "/cgi-bin/perl-test2.pl",
	*		data: $post1,
	*		encoding: "UTF-8", 
	*		type: 'POST',
	*		contentType: "text/json",
	*		dataType: "json"
$.ajax({
  method: "POST",
  url: "some.php",
  data: { name: "John", location: "Boston" }
})
  .done(function( msg ) {
    alert( "Data Saved: " + msg );
  });
	* 2. check if already in database √
	* 3. check if input is empty √
	* 4. drop down gets selectable tables from server -> table attribute per tag or table tags! 
	* -> better for querying. Values come from server, but also Name? on client side or in database??
	* 
	*/

    $.get( "/cgi-bin/perl-test.pl", function( data ) {

		console.log("hi from jquery");
  		if ($.isXMLDoc(data)){
  			var xml_node = $(data);
        	var host = xml_node.find('hostname').text() ;
			$( "#user" ).append( host );	
			// alert("XML received! " + host);
			// XML parser
			var opt = data.getElementsByTagName("opt");
			var table1 = opt[0].getAttribute("table1");

			var table3 = opt[0].getAttribute("table3");
//			alert(table3);

			var newOptions = {
				"Business English": table1,
  				"Sophisticated English": table3
			};

			var $el = $("#Table");
			$el.empty(); // remove old options
			$.each(newOptions, function(key,value) {
  			$el.append($("<option></option>")
     		.attr("value", value).text(key));
			});
  		}
	});

	// initialization
	
	$( "#tabs" ).tabs();
	$( "input[type=submit], button" ).button();
	
	$xml_post1 = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><vocabulary language="english" word="bias"/><vocabulary language="deutsch" word="Tendenz"/></data_body>';
		
	
	// event handling
	$("#test").click(function(){
		
	$xml_post2 = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><vocabulary language="english" word="brevity"/><vocabulary language="deutsch" word="Kürze"/></data_body>';
		
 
/*	$.ajax({
			url: "/cgi-bin/perl-test2.pl",
			data: $xml_post1, 
			type: 'POST',
			contentType: "text/xml",
			dataType: "xml",
			error : function(data){

			$( "div.demo-container" ).html( data );
			
			
			console.log( "Load was performed." );
		} 
	}); 
 */		
		$.post( "/cgi-bin/perl-test.pl",{  
			table: $("#Table").val(),
			language: 'english',
			translation: 'deutsch'
			}
		, function(data){

			$( "div.demo-container" ).html( data );
			
			
			console.log( "Load was performed." );

		});


 
    });

	$("#submit-lang").click(function(){

		$table = $("#Table").val();
		$value_eng = $("#English").val();
		$value_deu = $("#Deutsch").val();

		if (!$value_eng  || !$value_deu){
			alert("You forgot to fill in a translation!");
			return;
		}
  //   	$.ajax({
		// 	url: "/cgi-bin/insert_test.pl",
		// 	encoding: "UTF-8", 
		// 	type: 'POST',
		// 	contentType: "text/json; charset=utf-8",
		// 	dataType: "json",
		// 	data: {  
		//  		table: $table,
		//  		language: 'english',
		//  		translation: 'deutsch',
		//  		voc1: $value_eng,
		//  		voc2: $value_deu
		//  	}
		// 	}).done(function(data){

		// 	if ($.isXMLDoc(data)){
  // 				var xml_node = $(data);
  //       		var err_msg = xml_node.find('err_message').text() ;
		// 		alert(err_msg);
  // 			}
  // 			else{
  // 				$( "div.demo-container" ).html( data );
  // 			}
		// 	console.log( "Load was performed." );
		// });
		$.post( "/cgi-bin/insert_test.pl",{  
			table: $table,
			language: 'english',
			translation: 'deutsch',
			voc1: $value_eng,
			voc2: $value_deu
			}
		, function(data){

			if ($.isXMLDoc(data)){
  				var xml_node = $(data);
  				var err_msg = xml_node.find('err_message').text();
				alert(err_msg);
  			}
  			else{
  				$( "div.demo-container" ).html( data );
  			}
			console.log( "Load was performed." );

		});

	});

});