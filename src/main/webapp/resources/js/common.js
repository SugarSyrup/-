var Utils = {};

Utils.ajax = function(options, successcb, failcb) {
    $.ajax({
        type: options.type || 'post',
        url: options.url,
        data: options.data,
        beforeSend: function() {

        },
        success: function() {
            var data = arguments[0];
            successcb(data);
        },
        error: function() {
            var jsonError = arguments[0].responseJSON;
            if(failcb) {
                failcb(arguments);
            }
        },
        complete: function() {

        }
    });
}

Utils.getFormValue = function (formObj) {
    var arr = formObj.serializeArray();
    if (arr && arr.length > 0) {
        var values = {};
        for (var i in arr) {
            var obj = arr[i];
            values[obj.name] = obj.value
        }
        return values;
    }
    return null;
}

Utils.setFormValue = function (formObj, jsonData) {
    Utils.getFormValue(formObj);
    $.each(jsonData, function (key, value) {
        var ctrl = formObj.find('[name=' + key + ']');
        if (ctrl.is('select')) {
            $('option', ctrl).each(function () {
                if (this.value == value)
                    this.selected = true;
            });
        } else if (ctrl.is('textarea')) {
            ctrl.val(value);
        } else {
            switch (ctrl.attr("type")) {
                case "text":
                case "hidden":
                    ctrl.val(value);
                    break;
                case "checkbox":
                    if (value == 'on') {
                        ctrl.prop('checked', true);
                    } else {
                        ctrl.prop('checked', false);
                    }
                    break;
            }
        }
    });
}