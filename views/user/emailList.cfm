<cfscript>
  // determine how many emails per column
  local.nEmailsPerColumn = arrayLen(rc.arUsers)/4;
  // make sure we have at least 4 people
  if( local.nEmailsPerColumn < 4 ){
    local.nEmailsPerColumn = arrayLen(rc.arUsers);
  }
</cfscript>
<h1>Send User Email</h1>
<cfoutput><form action="#buildURL('user.sendEmail')#" method="post"></cfoutput>
  <div class="panel-group" id="accordion">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
            Step 1: Pick Users
          </a>
        </h4>
      </div>
      <div id="collapseOne" class="panel-collapse collapse in">
        <div class="panel-body" id="emailList">
          <div class="row">
            <div class="col-md-12">
              <div class="form-group">
                <div class="checkbox">
                  <label> <input type="checkbox" id="selectUnselectEmail"/> Select/Unselect All
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <cfloop from="1" to="#arrayLen(rc.arUsers)#" index="local.itm">
                <div class="form-group">
                  <div class="checkbox">
                    <label>
                      <cfoutput><input type="checkbox" class="email-addresses" data-email="#rc.arUsers[local.itm].getSEmail()#"/> #rc.arUsers[local.itm].getSFirstName()# #rc.arUsers[local.itm].getSLastName()#</cfoutput>
                    </label>
                  </div>
                </div>
                <cfif int(local.itm mod local.nEmailsPerColumn) eq 0>
                  </div>
                  <div class="col-md-3">
                </cfif>
              </cfloop>
            </div>
          </div>
        </div>
      </div>
      <div class="panel panel-default">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
            Step 2: Email Addressess
          </a>
        </h4>
      </div>
      <div id="collapseTwo" class="panel-collapse collapse">
        <div class="panel-body">
          Click once in the box below and then click CTRL+C (CMD+C on Mac) to copy addresses
          <textarea id="emailAddresses"></textarea>
        </div>
      </div>
    </div>
  </div>
</form>