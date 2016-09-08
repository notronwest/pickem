<div class="panel panel-default">
	<div class="panel-heading">
		<h4 style="float:none;">About</h4>
	</div>
	<div class="panel-body">
		<cfif compareNoCase("pickem", request.sLeagueKey) eq 0>
			<p>
			Football Pick'em is a combined NCAA and NFL league where you make picks based on the spreads of those games. Those spreads will be determined early in the week and will not change once they are set. We will do our best to balance college and NFL and will heavily favor those games that are being televised. There will be approximately 19 weeks to our league and the vast majority of the season will feature 10 NCAA and 10 NFL games per week whenever possible.  
			</p>

			<p>
			There will be payouts on a weekly basis as well as bigger payouts for overall winners at the end of the season. The amounts for payouts will be determined once the participants are finalized.
			</p>

			<p>
			The fee will be $55 with $5 of that fee going toward the expenses associated with the site (in addition to the person running the site getting a free entry). That means over 90% of the money gets paid back out in various prizes.  
			</p>

			<p>
			You will be able to make all picks and see the complete standings on the site with the hope of real-time scoring updates on the site, too, so you can see where you stand on any given week. You can spend as little or as much time as you want each week researching your picks or just have your picks auto-selected for you if you’d like.
			</p>

			<p>
			Feel free to invite anyone you want to the league. Just have them register their name and email at pickem.inquisibee.com and PayPal Evan McKechnie at evanmckechnie@gmail.com.
			</p>
		<cfelseif compareNoCase("NFLPerfection", request.sLeagueKey) eq 0>
			<p>
			The NFL Perfection Challenge is a season long pool that allows the participants to pick the winners (without spreads) of any NFL games that week and as many as they would like in any given week. Participants will get one point for each game they get correct that week, but will score zero points that week of ANY if they miss one or more of their picks. Payouts will be based on season-ending point totals.
			</p>

			<p>
			There will be payouts for overall winners at the end of the season. The amounts for payouts will be determined once the participants are finalized.
			</p>

			<p>
			The fee will be $55 with $5 of that fee going toward the expenses associated with the site (in addition to the person running the site getting a free entry). That means over 90% of the money gets paid back out in various prizes.  
			</p>

			<p>
			You will be able to make all picks and see the complete standings on the site with the hope of real-time scoring updates on the site, too, so you can see where you stand on any given week. You can spend as little or as much time as you want each week researching your picks or just have your picks auto-selected for you if you’d like.
			</p>

			<p>
			Feel free to invite anyone you want to the league. Just have them register their name and email at pickem.inquisibee.com and PayPal Evan McKechnie at evanmckechnie@gmail.com.
			</p>
		</cfif>
	</div>
</div>