<section id="content">
	<cfoutput><form>
		<h2>Are you sure you would like to delete this user?</h2>
		<p>#rc.oUser.getSFirstName()# #rc.oUser.getSLastName()#</p>
		<div class="control-group">
			<div class="controls">
				<button type="button" class="save" id="doUserDelete">Delete</button><button type="button" class="cancel">Cancel</button>
			</div>
		</div>
		<input type="hidden" id="nUserID" value="#rc.oUser.getNUserID()#"/>
	</form></cfoutput>
</section>