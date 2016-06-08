
$( document ).ready(function() {

    $.get( "/cgi-bin/perl-test2.pl", function( data ) {

		console.log("hi from jquery");

	});

	// initialization
	
	$("#test").button();
	
	$xml_post2 = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><vocabulary language="english" word="bias"/><vocabulary language="deutsch" word="Tendenz"/></data_body>';
		
	
	// event handling
	$("#test").click(function(){
		
	$xml_post1 = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><vocabulary language="english" word="brevity"/><vocabulary language="deutsch" word="Kürze"/></data_body>';
		
 
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

		
		$.post( "/cgi-bin/perl-test2.pl",{  
			table: 'business_english',
			language: 'english',
			translation: 'deutsch',
			voc1: 'brevity',
			voc2: 'Kuerze'
			}
		, function(data){

			$( "div.demo-container" ).html( data );
			
			
			console.log( "Load was performed." );

		});


 
    })


});

