<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading">No Pay, No Play</div> 
		<div class="panel-body">
			<div class="alert alert-info">
				The league fee will be $50 again and you can pay me via PayPal at: evanmckechnie@gmail.com <br/>or mail me a check at: Evan McKechnie, 6114 SW 50th Ave, 
				Portland OR 97221.
			</div>
			<image id="nopayimage"/>
		</div>
	</div>
	<script>
		var arImages = [
			<cfloop from="1" to="#arrayLen(rc.arImages)#" index="local.itm">"#rc.arImages[local.itm]#",</cfloop>
		];
		docReady(function(){
			setImage();
			setInterval(function(){
				setImage();
			}, 5000);
		});
		function setImage(){
			var nItem = Math.floor(Math.random() * #arrayLen(rc.arImages)#) + 0 
			$("##nopayimage").prop("src", "/assets/images/nopaynoplay/" + arImages[nItem]);
		}
	</script>
</cfoutput>