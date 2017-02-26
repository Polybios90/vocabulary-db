
$( document ).ready(function() {

	/*
	/* TODOs
	* 1. send UTF8 √
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
	* encode/ decode perl if no cyrillic is sent?! research -> add to stackoverflow answer
	* set SQL server charset
	* set Apache server charset
	* set HTTP header charset
	* set perl database handle charset

	* 2. check if already in database √
	* 3. check if input is empty √
	* 4. drop down gets selectable tables from server -> table attribute per tag or table tags! 
	* -> better for querying. Values come from server, but also Name? on client side or in database??
	* 5. Create table functions on server for uniform table handling √
	* 6. use jQuery tables!
	* 7. (auto) backups of tables
	* 8. sub prototypes √
	* 9. add jquery DataTables for nicer design and extra functionality for html tables √
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
			var table2 = opt[0].getAttribute("table2");
			var table3 = opt[0].getAttribute("table3");
//			alert(table3);

			var newOptions = {
				"Business English": table1,
				"Russian": table2,
  				"Sophisticated English": table3
			};
			/*
			var $el = $("#Table");
			$el.empty(); // remove old options
			$.each(newOptions, function(key,value) {
  			$el.append($("<option></option>")
     		.attr("value", value).text(key));
			});
			*/
  		}
	});

	// initialization
	
	$( "#tabs" ).tabs();
	$( "input[type=submit], button" ).button();
	
	$xml_post1 = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><vocabulary language="english" word="bias"/><vocabulary language="deutsch" word="Tendenz"/></data_body>';
	
	// event handling

	$("#submit-lang").click(function(){

		$table = $("#Table").val();
		$translation = 'english';
		if($table == "mixed_russki"){
			$translation = 'russian'
		}
		$value_trans = $("#Translation").val();
		$value_deu = $("#Deutsch").val();

		if (!$value_trans  || !$value_deu){
			alert("You forgot to fill in a translation!");
			return;
		}

		$.post( "/cgi-bin/insert_test.pl",{  
			table: $table,
			translation: $translation,
			german: 'deutsch',
			voc1: $value_trans,
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

	$("#Table").change(function(){
		if($("#Table").val() == "mixed_russki") {
			$("#Translation-Label").html("Russian");
		}
		else{
			$("#Translation-Label").html("English");
		}
		$table = $("#Table").val();

		$translation = 'english';
		if($table == "mixed_russki"){
			$translation = 'russian'
		}

		$.post( "/cgi-bin/retrieve_table.pl",{  
			table: $table,
			translation: $translation,
			german: 'deutsch'
			}
		, function(data){

			$( "div.demo-container" ).html( data );
			$('#dyn-table-id').DataTable();			
			
			console.log( "Retrieved table." );

		});

	});


	// trigger event on document ready
	$( "#Table" ).trigger( "change" );

	
});