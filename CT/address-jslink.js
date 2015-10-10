var addressLine1 = "addressLine1", addressLine2 = "addressLine2", addressCity = "addressCity", addressState = "addressState", addressZip = "addressZip", errorContainer = "divErrorMessage";

(function () {
    if (typeof SPClientTemplates === 'undefined')
        return;

    var addressCtx = {};

    addressCtx.Templates = {};
    //associate the various templates with rendering functions for our field.
    //when a list view is returned to the user, SharePoint will fire the function associate with 'View'.
    //when a list item is in New, SharePoint will fire the function associated with NewForm, etc.
    addressCtx.Templates.Fields = {
        //Address is the Name of our field
        'Address': {
            'View': addressView,
            'DisplayForm': addressDisplayForm,
            'EditForm': addressNewAndEditForm, //using the same function for New and Edit, but they could be different
            'NewForm': addressNewAndEditForm
        }
    };

    //register the template to render our field
    SPClientTemplates.TemplateManager.RegisterTemplateOverrides(addressCtx);

})();

//=======================================================================================================
//helper methods
//=======================================================================================================

function getCustomFieldValue(ctx) {
    var val = '';
    if (ctx != null && ctx.CurrentItem != null)
        val = ctx.CurrentItem[ctx.CurrentFieldSchema.Name];

    return val;
}

//Custom address validator
AddressFieldValidator = function () {
 
    AddressFieldValidator.prototype.Validate = function (value) {
 
    value = SPClientTemplates.Utility.Trim(value);
    var data = JSON.parse(value);
    var hasError = false;
    var errorMsg = "";
     
    if(data.Line1=='' || data.City=='' || data.Zip=='' || data.State== ''){
        hasError = true;
        errorMsg = "Only Address Line 2 is optional...";
    }
    
    return new SPClientForms.ClientValidation.ValidationResult(hasError, errorMsg);
 
	};
};

//registers call back functions from SharePoint
function RegisterCallBacks(formCtx) {

    //After the user clicks save, call this function. In this function, set the item field value.
    formCtx.registerGetValueCallback(formCtx.fieldName, function () {
        // Read value from this callback and assign to the field before save.
        var data = {};
        data["Line1"] = $("#" + addressLine1).val();
        data["Line2"] = $("#" + addressLine2).val() ;
        data["City"] = $("#" + addressCity).val() ; 
        data["State"] = $("#" + addressState).val() ; 
        data["Zip"] = $("#" + addressZip).val() ;
        var fieldVal = JSON.stringify(data);
        //alert(fieldVal);
        return fieldVal;

    });

    //create container for various validators
    var validators = new SPClientForms.ClientValidation.ValidatorSet();

    //if the field is required, make sure we handle that
    if (formCtx.fieldSchema.Required) {
        //add a required field validator to the collection of validators
        validators.RegisterValidator(new SPClientForms.ClientValidation.RequiredValidator());
    }
    //register custom validator
    validators.RegisterValidator(new AddressFieldValidator());
    
    //if we have any validators, register those
    if (validators._registeredValidators.length > 0) {
        formCtx.registerClientValidator(formCtx.fieldName, validators);
    }

    //when there's a validation error, call this function
    formCtx.registerValidationErrorCallback(formCtx.fieldName, function (errorResult) {
        SPFormControl_AppendValidationErrorMessage(errorContainer, errorResult);
    });
}

//render the value from the current item
function RenderExistingValues(ctx, editMode) {
    var currentValue = getCustomFieldValue(ctx);
	var data = {};
	if(currentValue==''){
		data["Line1"] = "";
		data["Line2"] = "";
		data["City"] = "";
		data["State"] = "";
		data["Zip"] = "";
	}else{
		var decodedValue = STSHtmlDecode(currentValue);
		data = JSON.parse(decodedValue); 
	}
    var html = '<table>';
    if(editMode){
        html += '<tr><td>Address Line 1:</td><td><input id="' + addressLine1 + '" type="text" value="' + data.Line1 +'"></td></tr>';
        html += '<tr><td>Address Line 2:</td><td><input id="' + addressLine2 + '" type="text" value="' + data.Line2 +'"></td></tr>';
        html += '<tr><td>City:</td><td><input id="' + addressCity + '" type="text" value="' + data.City +'"></td></tr>';
        html += '<tr><td>State:</td><td><input id="' + addressState + '" type="text" value="' + data.State +'"></td></tr>';
        html += '<tr><td>ZIP:</td><td><input id="' + addressZip + '" type="text" value="' + data.Zip +'"></td></tr>';
    }else{
        html += '<tr><td>Address Line 1:</td><td><span>' + data.Line1 +'</span></td></tr>';
        html += '<tr><td>Address Line 2:</td><td><span>' + data.Line2 +'</span></td></tr>';
        html += '<tr><td>City:</td><td><span>' + data.City +'</span></td></tr>';
        html += '<tr><td>State:</td><td><span>' + data.State +'</span></td></tr>';
        html += '<tr><td>ZIP:</td><td><span>' + data.Zip +'</span></td></tr>';
    }
    
    html += '</table><div id="' + errorContainer + '"></div>';
    return html;
}





//function called when our field is shown in a View
function addressView(ctx) {
	debugger;
	var currentValue = getCustomFieldValue(ctx);
	var decodedValue = STSHtmlDecode(currentValue);
	data = JSON.parse(decodedValue);
	var html = "<div>" + data.Line1 + "," + data.Line2 + ","  + data.City + "," + data.State + "," + data.Zip + "</div>";
	return html;
}

//function is called with item is displayed on Display form
function addressDisplayForm(ctx) {
debugger;
    if (ctx == null || ctx.CurrentFieldValue == null)
        return '';

    return RenderExistingValues(ctx, false);
}

//function called when an item with our field is in edit mode or new mode.
function addressNewAndEditForm(ctx) {
debugger;
    if (ctx == null || ctx.CurrentFieldValue == null)
        return '';

    var formCtx = SPClientTemplates.Utility.GetFormContextForCurrentField(ctx);
    if (formCtx == null || formCtx.fieldSchema == null)
        return '';

    //register callback functions that SharePoint will call at appropriate times
    RegisterCallBacks(formCtx);

    //render existing values
    html = RenderExistingValues(ctx,true);

    return html;
}






