<cfoutput><form role="form" id="bulk">
  <div class="form-group">
    <label for="nWeekID">Week:</label>
    <select class="form-control" id="nWeekID">
      <option value="">Select</option>
      <cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
        <option value="#rc.arWeeks[local.itm].getNWeekID()#">#rc.arWeeks[local.itm].getSName()#</option>
      </cfloop>
    </select>
  </div>
  <div class="form-group">
    <label for="nUserID">User:</label>
    <select class="form-control" id="nUserID">
      <option value="" data-id="0">Select</option>
      <cfloop from="1" to="#arrayLen(rc.arUsers)#" index="local.itm">
        <option value="#rc.arUsers[local.itm].getNUserID()#" data-id="#rc.arUsers[local.itm].getNUserID()#">#rc.arUsers[local.itm].getSFirstName()# #rc.arUsers[local.itm].getSLastName()# (#rc.arUsers[local.itm].getSEmail()#)</option>
      </cfloop>
    </select>
  </div>
  <div class="form-group">
  	<label for="sPicks">Picks:</label>
  	<textarea name="sPicks" id="sPicks" rows="10" cols="40"></textarea>
  </div>
  <div class="form-group">
  	<button id="save" type="button">Save</button>
  </div>
 </form></cfoutput>