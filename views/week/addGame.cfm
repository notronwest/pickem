<section id="content">
	<form id="addEditForm" class="form-horizontal">
		<div class="control-group">
			<label for="sHomeTeam" class="control-label">Home Team: </label>
			<div class="controls">
				<select id="sHomeTeam" size="1">
					<option value="">Select</option>
					<cfloop from="1" to="#arrayLen(rc.arTeams)#" index="itm">
						<cfoutput><option value="#rc.arTeams[itm].getSName()#">#rc.arTeams[itm].getSName()#</option></cfoutput>
					</cfloop>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label for="sAwayTeam" class="control-label">Away Team: </label>
			<div class="controls">
				<select id="sAwayTeam" size="1">
					<option value="">Select</option>
					<cfloop from="1" to="#arrayLen(rc.arTeams)#" index="itm">
						<cfoutput><option value="#rc.arTeams[itm].getSName()#">#rc.arTeams[itm].getSName()#</option></cfoutput>
					</cfloop>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label for="dGameDate" class="control-label">Date: </label>
			<div class="controls"><input type="text" id="dGameDate" value=""/></div>
		</div>
		<div class="control-group">
			<label for="nSpread" class="control-label">Spread: </label>
			<div class="controls"><input type="text" id="nSpread" value=""/></div>
		</div>
		<div class="control-group">
			<label for="sSpreadFavor" class="control-label">Spread Favor: </label>
			<div class="controls">
				<select id="sSpreadFavor" size="1">
					<option value="home">home</option>
					<option value="away">away</option>
				</select>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<button type="button" class="save" id="addGame">Add</button><button type="button" class="cancel">Cancel</button>
			</div>
		</div>
	</form>
</section>