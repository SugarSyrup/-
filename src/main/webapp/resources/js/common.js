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

Utils.calculateCurrentTimes = async function (beforeYear, beforeMonth, registYear, registMonth, registDay, flagDate) {
    let beforeMonthTimes = 0;
    let currentMonthTimes = 0;

    let inputMonth = registMonth + "";
    if (registMonth < 10) {
        inputMonth = "0" + inputMonth;
    }

    //만근 유무 판단하기
    let isFullWorked = 1;
    await fetch("https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?serviceKey=u6RcVsFR208vg2Vldw7UE%2BYn7T0GztD1MT%2FuY%2FMwo1Ya5uYcWCqFBUcoRkVykof%2FN%2BBymKAWQ2P2%2FPNTahz4%2Fg%3D%3D&solYear=" + registYear + "&solMonth=" + inputMonth + "&_type=json")
        .then((response) => response.json())
        .then((data) => {
            let restDates = []
            if(data.response.body.items == "") {

            } else {
                if (data.response.body.totalCount == 1) {
                    restDates = [data.response.body.items.item.locdate % 10];
                } else {
                    restDates = data.response.body.items.item.map((item) => item.locdate % 100);
                }
            }
            for (let i = 1; i < parseInt(registDay); i++) {
                let indexDay = new Date(registYear + "-" + registMonth + "-" + i).getDay();
                // 만근인가요 ? 1 : 0
                if (indexDay == 0 || indexDay == 6 || restDates.find((value) => value == i) == i) {
                } else {
                    isFullWorked = 0;
                    break;
                }
            }

            //beforeMonthTimees : 이전직장에서 다닌 근무 기간 (월 단위)
            beforeMonthTimes = beforeYear * 12 + beforeMonth;
            //currentMonthTimes : 네오텍 근무 기간 ( 기준 년도 - 입사 년도 -1 ) x 12 + 입사 일 ~ 그 해 12.31 + 1.1 ~ 기준 일
            currentMonthTimes = (flagDate.getFullYear() - registYear - 1) * 12 + ( 12 - registMonth ) + (flagDate.getMonth() + 1) + isFullWorked;

            //기준일이 해당 달의 말일인지 판단하기
            flagDate.setDate(flagDate.getDate() + 1);
            if (flagDate.getDate() == 1) {
            } else {
                currentMonthTimes = currentMonthTimes - 1;
            }

            if(registMonth < 10){
                registMonth = "0" + registMonth;
            }
            if(registDay < 10){
                registDay = "0" + registDay;
            }
        });
    return Promise.resolve({beforeMonthTimes, currentMonthTimes});
}