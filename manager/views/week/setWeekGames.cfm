<cfoutput>
<div id="setWeek" class="panel panel-default" data-id="#rc.oWeek.getNWeekID()#">
	<div class="panel-heading text-right">
		<form class="form-inline" role="form">
			<div class="form-group">
				<select id="sWeekURL" class="input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('week.setWeekGames')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
							#rc.arWeeks[local.itm].getSName()# (#dateFormat(rc.arWeeks[local.itm].getDStartDate(), "mm/dd")# - #dateFormat(rc.arWeeks[local.itm].getDEndDate(), "mm/dd")#)
						</option>
					</cfloop>
				</select>
				<button class="btn btn-default change-week btn-sm" type="button">Go</button>
			</div>
		</form>
	</div>
	<div class="panel-body">
		<!--- // if the week is locked --->
		<cfif rc.bIsLocked>
			<div class="alert alert-warning">
				<h3>This week is currently locked.  Would you like to override this lock to add/delete games?</h3>
				<blockquote>Note: deleting games that existed in the past could disrupt picks made by users</blockquote>
				<div class="form-group">
					<button id="overrideLock" class="btn btn-default btn-sm" data-url="#buildURL('week.setWeekGames')#&nWeekID=#rc.oWeek.getNWeekID()#&bOverrideLock=true">Override Lock</button>
				</div>
			</div>
		<cfelse>
			<h1>#rc.oWeek.getSName()#</h1>
			<div>
				<span id="sStartDate">#rc.oWeek.getDStartDate()#</span> - <span id="sEndDate">#rc.oWeek.getDEndDate()#</span>
				<br/>Picks due: #rc.dtPicksDue# PT
			</div>
			<div class="loading"><img src="/assets/images/ajax-loader.gif"/> Loading available games ...</div>
			<div id="games">
				<div class="game-actions text-right">
					<button class="save-games btn btn-sm btn-default disabled" type="button">Save Games</button>
					<button type="button" class="add-game btn btn-sm btn-success">Add Game</button>
				</div>
				<!--- // if there are games already created - load them --->
				<h3>Active Games</h3>
				<div class="checkbox">
					<label for="showLock">
						<input type="checkbox" id="showLock"> Show Lock Date/Time
					</label>
				</div>
				<form id="weekGames" method="post" action="#buildURL('game.saveWeek')#">
					<input type="hidden" name="arGames" id="arGames" value=""/>
					<input type="hidden" name="nWeekID" id="nWeekID" value="#rc.nWeekID#"/>
				</form>
				<div class="table-responsive">
					<table class="table" id="activeGames">
						<thead>
							<th></th>
							<th>Favorite</th>
							<th>Underdog</th>
							<th>Game Date</th>
							<th>Game Time</th>
							<th class="lock-control hide">Lock Date</th>
							<th class="lock-control hide">Lock Time</th>
							<th>Spread</th>
							<th>Tiebreak</th>
							<th></th>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
			<!---// available games to pick from --->
			<div id="source" class="hide">
				<h3>Available Games</h3>
				<div class="table-responsive">
					<table class="table" id="availableGames">
						<thead>
							<th></th>
							<th>Favorite</th>
							<th>Underdog</th>
							<th>Date</th>
							<th></th>
							<th></th>
							<th></th>
							<th>Spread</th>
							<th>Tiebreak</th>
							<th></th>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>

			<script>
				// load the games
				docReady(function(){
					getGames();
				});
			</script>
		</cfif>
	</div>
</div>
<div id="results" class="hide"></div>
<div class="text-right">
	<a href="javascript:;" class="help">Help</a>
	<div class="help hide">
		<h5>Set Games</h5>
		<ol>
			<li>"Set Games" is where you build each week and its games.</li>
			<li>Click the week in the left column.  You should get a list of all of the games for NCAA and NFL</li>
			<li>Click the plus sign next to the games in the "Available Games" list to move them into the "Active Games" list</li>
			<li>Adjust the Spread and set the Tiebreak games and then click "Save Games"</li>
			<li>Once you set the games you won''t see the list of "Available Games" again.  If you missed a game just chose "Add Game" and you will be able to set the game manually</li>
			<li>Games can be ordered however you want (just drag and drop the games in the list of "Active Games" and then click "Save Games"</li>
		</ol>
	</div>
</div></cfoutput>
<table id="defaultGame" class="hide">
	<tr class="game" data-game-id="">
		<td><span class="fa fa-sort move icons fa-fw fa-lg" title="Move into active games"><input type="hidden" class="spread-favor"/></span></td>
		<td><input type="text" name="favorite" class="form-control input-sm favorite" data-id="" data-url=""/></td>
		<td><input type="text" name="underdog"class="form-control input-sm underdog" data-id="" data-url=""/></td>
		<td><input type="text" name="date" class="form-control input-sm game-date date control-md"/></td>
		<td><input type="text" name="gameTime" class="form-control input-sm time game-time control-md"/></td>
		<td class="lock-control hide"><input type="text" name="lock" class="form-control input-sm lock-date date control-md"/></td>
		<td class="lock-control hide"><input type="text" name="lockTime" class="form-control input-sm time lock-time control-md"/></td>
		<td><input type="number" name="spread" class="form-control input-sm spread control-sm"/></td>
		<td><input type="number" name="tiebreak" class="form-control input-sm tiebreak control-sm"/></td>
		<td><span title="Delete Game" class="fa fa-trash-o delete icons fa-fw fa-lg"></span> <span title="Swap HOME/Away Teams" class="fa fa-home swap-home icons fa-lg"></span> <span title="Swap Spread" class="fa fa-exchange swap-spread icons fa-lg"></span>
		<input type="hidden" name="nType" class="nType">
		<input type="hidden" name="sAPIID" class="sAPIID"></td>
	<tr>
</table>
