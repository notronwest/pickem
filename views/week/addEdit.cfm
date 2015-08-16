<cfoutput>
	<form id="addEditForm" class="form" action="#buildURL('week.save')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3><cfif rc.oWeek.getNWeekID() gt 0>Edit<cfelse>Add</cfif> Week</h3>
		</div>
		<div class="panel-body">
				<div class="form-group">
					<label for="sName">Name: </label>
					<input type="text" name="sName" id="sName" class="form-control" value="#rc.oWeek.getSName()#"/>
				</div>
				<div class="form-group">
					<label for="dStartDate">Start: </label>
					<input type="text" name="dStartDate" id="dStartDate" class="form-control" value="#rc.oWeek.getDStartDate()#"/>
				</div>
				<div class="form-group">
					<label for="dEndDate">End: </label>
					<input type="text" name="dEndDate" id="dEndDate" class="form-control" value="#rc.oWeek.getDEndDate()#"/>
				</div>
				<div class="form-group">
					<label for="dPicksDue">Picks Due (date): </label>
					<input type="text" name="dPicksDue" id="dPicksDue" class="form-control" value="#rc.oWeek.getDPicksDue()#"/>
				</div>
				<div class="form-group">
					<label for="tPicksDue">Picks Due (time ET): </label>
					<input type="text" name="tPicksDue" id="tPicksDue" class="form-control" value="<cfif len(rc.oWeek.getTPicksDue()) gt 0>#rc.oWeek.getTPicksDue()#<cfelse>09:00</cfif>"/>
					<span class="help-block">Use 24 hour time (e.g. 14:00 would be 2 PM)</span>
				</div>
				<!--- // <div class="checkbox">
					Sports:
						<label for="NCAA"><input type="checkbox" name="lstSports" id="NCAA" value="NCAA" class="sports"<cfif listFindNoCase(rc.oWeek.getLstSports(), "NCAA")> checked="checked"</cfif>/> NCAA</label> <label for="NFL"><input type="checkbox" name="lstSports" id="NFL" value="NFL" class="sports"<cfif listFindNoCase(rc.oWeek.getLstSports(), "NFL")> checked="checked"</cfif>/> NFL</label>
				</div>
				<div class="form-group">
					<div class="checkbox">
						<label for="nBonus"><input type="checkbox" name="nBonus" id="nBonus"<cfif rc.oWeek.getNBonus() eq 1> checked="checked"</cfif>/> Bonus week (*)</label>
					</div>
				</div> --->
				<input type="hidden" name="nSeasonID" value="#rc.nSeasonID#"/>
				<input type="hidden" name="nWeekID" id="nWeekID" value="#rc.oWeek.getNWeekID()#"/>
			</div>
		</div>
		<div class="panel-footer text-right">
			<button type="button" class="btn btn-danger cancel">Cancel</button> <button class="btn btn-primary save" id="addEditWeek">Save</button>
			<!--- // if this is an add make sure we don't edit the current week --->
			<cfif rc.bAdd>
				<input type="hidden" name="bAdd" value="true"/>
			</cfif>
		</div>

	</form>
</cfoutput>
<script>
	$(function(){
		// set dates
		$("#dStartDate,#dEndDate,#dPicksDue").datepicker( { dateFormat: "yy-mm-dd" } );
	});
</script>