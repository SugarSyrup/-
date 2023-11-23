<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<%@ page import="com.example.leavesmanagement.entity.SessionUser" %>
<%
    SessionUser user = (SessionUser) session.getAttribute("user");
    pageContext.setAttribute("user", user);
%>

<t:layout>
    <jsp:attribute name="styles">
        <link rel="stylesheet" href="resources/css/table.css" >
        <link rel="stylesheet" href="resources/css/users.css" >
    </jsp:attribute>
    <jsp:attribute name="script">
        <!-- Sheet JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
        <!--FileSaver savaAs 이용 -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
        <script>
            const registBtns = document.getElementsByClassName("registBtn");
            const header = document.querySelector(".header");
            header.innerText = "총 연휴 등록하기";

            for(let i = 0; i<registBtns.length; i++) {
                registBtns[i].addEventListener('click', (e) => {
                    document.querySelector(".modal_wrapper").open = true;
                    document.getElementById("user_no").value = e.currentTarget.dataset.userno;
                    document.getElementById("modalRegist").style.display = "flex";
                    document.getElementById("modalTotal").style.display = "none";
                })
            }

            function renderModal() {
                const yearSelect = document.getElementById("year");
                const monthSelect = document.getElementById("month");
                const enterDate = document.getElementById("enter_date");

                const timeflag = document.getElementsByClassName("timeflag");

                //작년 구하기
                let now = new Date();
                let lastYear = new Date(now.setFullYear(now.getFullYear() - 1));
                for(let i = 0; i<timeflag.length; i++) {
                    const tmp = (lastYear.getFullYear());
                    timeflag[i].innerText = "(" + tmp + ".12 기준)";
                }

                Utils.calculateCurrentTimes(parseInt(yearSelect.value), parseInt(monthSelect.value), parseInt(enterDate.value.split("-")[0]), parseInt(enterDate.value.split("-")[1]), parseInt(enterDate.value.split("-")[2]), new Date())
                    .then(({beforeMonthTimes,currentMonthTimes}) => {
                        const calcResults = document.getElementsByClassName("calcResult");

                        let monthText = currentMonthTimes%12 < 10 ? "0"+currentMonthTimes%12 : currentMonthTimes%12+"";
                        let totalMonthText = (beforeMonthTimes + currentMonthTimes)%12 < 10 ? "0"+(beforeMonthTimes + currentMonthTimes)%12 : (beforeMonthTimes + currentMonthTimes)%12+""

                        calcResults[0].innerText = parseInt(currentMonthTimes / 12) + "년 " + monthText + "월";
                        calcResults[1].innerText = parseInt((beforeMonthTimes + currentMonthTimes) / 12) + "년 " + totalMonthText + "월";
                        calcResults[2].innerText = parseInt((parseInt((currentMonthTimes - now.getMonth() - 1) / 12) - 1) / 2)  + "일";
                    })
            }

            const yearSelect = document.getElementById("year");
            const monthSelect = document.getElementById("month");
            const enterDate = document.getElementById("enter_date");

            const timeflag = document.getElementsByClassName("timeflag");
            const calcResult = document.getElementById("calcResult");

            //작년 구하기
            let now = new Date();
            let lastYear = new Date(now.setFullYear(now.getFullYear() - 1));
            for(let i = 0; i<timeflag.length; i++) {
                timeflag[i].innerText = "(" + (lastYear.getFullYear()) + ".12 기준)";
            }

            [yearSelect, monthSelect].map((ele) => {
                ele.addEventListener('input', (e) => {
                    Utils.calculateCurrentTimes(parseInt(yearSelect.value), parseInt(monthSelect.value), parseInt(enterDate.value.split("-")[0]), parseInt(enterDate.value.split("-")[1]), parseInt(enterDate.value.split("-")[2]), new Date())
                        .then(({beforeMonthTimes,currentMonthTimes}) => {
                            const calcResults = document.getElementsByClassName("calcResult");

                            let monthText = currentMonthTimes%12 < 10 ? "0"+currentMonthTimes%12 : currentMonthTimes%12+"";
                            let totalMonthText = (beforeMonthTimes + currentMonthTimes)%12 < 10 ? "0"+(beforeMonthTimes + currentMonthTimes)%12 : (beforeMonthTimes + currentMonthTimes)%12+""

                            calcResults[0].innerText = parseInt(currentMonthTimes / 12) + "년 " + monthText + "월";
                            calcResults[1].innerText = parseInt((beforeMonthTimes + currentMonthTimes) / 12) + "년 " + totalMonthText + "월";
                            calcResults[2].innerText = parseInt((parseInt((currentMonthTimes - now.getMonth() - 1) / 12) - 1) / 2)  + "일";
                        });
                })
            })

            enterDate.addEventListener('input',(e) => {
                Utils.calculateCurrentTimes(parseInt(yearSelect.value), parseInt(monthSelect.value), parseInt(enterDate.value.split("-")[0]), parseInt(enterDate.value.split("-")[1]), parseInt(enterDate.value.split("-")[2]), new Date())
                    .then(({beforeMonthTimes,currentMonthTimes}) => {
                        const calcResults = document.getElementsByClassName("calcResult");

                        let monthText = currentMonthTimes%12 < 10 ? "0"+currentMonthTimes%12 : currentMonthTimes%12+"";
                        let totalMonthText = (beforeMonthTimes + currentMonthTimes)%12 < 10 ? "0"+(beforeMonthTimes + currentMonthTimes)%12 : (beforeMonthTimes + currentMonthTimes)%12+""

                        calcResults[0].innerText = parseInt(currentMonthTimes / 12) + "년 " + monthText + "월";
                        calcResults[1].innerText = parseInt((beforeMonthTimes + currentMonthTimes) / 12) + "년 " + totalMonthText + "월";
                        calcResults[2].innerText = parseInt((parseInt((currentMonthTimes - now.getMonth() - 1) / 12) - 1) / 2)  + "일";
                    });
            })
        </script>
        <script>
            const editBtns = document.getElementsByClassName("editBtn");

            for(let i = 0; i<editBtns.length; i++) {
                editBtns[i].addEventListener('click', (e) => {
                    document.getElementById("modalRegist").style.display = "flex";
                    document.getElementById("modalTotal").style.display = "none";

                    let data;
                    document.querySelector(".modal_wrapper").open = true;
                    document.getElementById("user_no").value = e.currentTarget.dataset.userno;
                    data = {
                        "user_no" : e.currentTarget.dataset.userno
                    }

                    fetch("http://" + window.location.host + "/getUserDateData", {
                        method:'post',
                        headers: {
                            "Content-Type" : "application/json",
                        },
                        body: JSON.stringify(data)
                    }).then((response) => response.json())
                        .then((data) => {
                            header.innerText = "총 연휴 수정하기";
                            //이전 기업 년도 지정
                            for(var i = 0; i<yearSelect.options.length; i++) {
                                if(yearSelect.options[i].value == data.before_date.split("/")[0]) {
                                    yearSelect.options[i].selected = true;
                                }
                            }

                            //이전 기업 월 지정
                            for(var i = 0; i<monthSelect.options.length; i++) {
                                if(monthSelect.options[i].value == data.before_date.split("/")[1]) {
                                    monthSelect.options[i].selected = true;
                                }
                            }

                            //입사 일자 지정
                            enterDate.value = data.enter_date;
                            renderModal();
                        });
                })
            }

            const deleteBtns = document.getElementsByClassName("delete-button");
            for(let i = 0; i <deleteBtns.length; i++) {
                deleteBtns[i].addEventListener('click', () => {
                    const deleteBtn = deleteBtns[i];
                    const data = {
                        user_no : deleteBtn.dataset.id
                    };

                    fetch("http://" + window.location.host + "/userDelete", {
                        method:'post',
                        headers: {
                            "Content-Type" : "application/json",
                        },
                        body: JSON.stringify(data)
                    }).then(() => location.reload())
                })
            }

            const restoreBtns = document.getElementsByClassName("restore-button");
            for(let i = 0; i <restoreBtns.length; i++) {
                restoreBtns[i].addEventListener('click', () => {
                    const restoreBtn = restoreBtns[i];
                    const data = {
                        user_no : restoreBtn.dataset.id
                    };

                    fetch("http://" + window.location.host + "/userRestore", {
                        method:'post',
                        headers: {
                            "Content-Type" : "application/json",
                        },
                        body: JSON.stringify(data)
                    }).then(() => location.reload())
                })
            }

            let paginationIndex = 1;
            const totalModalOpen = document.getElementById("openTotal");
            const totalTable = document.getElementById("totalTable");
            const trs = totalTable.getElementsByClassName("tr");
            const excelTrs = document.getElementById("excelTable").getElementsByClassName("tr");
            totalModalOpen.addEventListener('click', () => {
                document.querySelector(".modal_wrapper").open = true;
                document.getElementById("modalRegist").style.display = "none";
                document.getElementById("modalTotal").style.display = "flex";

                const flagDateInput = document.getElementById("flagDate");

                function tableRender() {
                    for(let j = 0; j <trs.length; j++) {
                        let beforeYear = parseInt(trs[j].dataset.beforedate.split("/")[0]);
                        let beforeMonth = parseInt(trs[j].dataset.beforedate.split("/")[1]);
                        let registYear = parseInt(trs[j].dataset.enterdate.split("-")[0]);
                        let registMonth = parseInt(trs[j].dataset.enterdate.split("-")[1]);
                        let registDay = parseInt(trs[j].dataset.enterdate.split("-")[2]);
                        let flagDate = new Date(flagDateInput.value);

                        let Loading = `
                            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="margin: auto; background: rgb(255, 255, 255); display: block; shape-rendering: auto; animation-play-state: running; animation-delay: 0s; position:relative; top:inherit; right:inherit; width:24px; height:24px;" width="24px" height="24px" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" >
                                <g transform="rotate(0 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.9166666666666666s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(30 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.8333333333333334s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(60 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.75s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(90 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.6666666666666666s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(120 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.5833333333333334s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(150 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.5s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(180 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.4166666666666667s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(210 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.3333333333333333s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(240 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.25s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(270 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.16666666666666666s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(300 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.08333333333333333s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                                <g transform="rotate(330 50 50)" style="animation-play-state: running; animation-delay: 0s;">
                                    <rect x="48" y="28" rx="1.84" ry="1.84" width="4" height="4" fill="#000000" style="animation-play-state: running; animation-delay: 0s;">
                                        <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="0s" repeatCount="indefinite" style="animation-play-state: running; animation-delay: 0s;"></animate>
                                    </rect>
                                </g>
                            </svg>`;
                        trs[j].innerHTML = "<td>" + Loading + "</td>"
                            + "<td>" + Loading + "</td>"
                            + "<td>" + Loading + "</td>"
                            + "<td>" + Loading + "</td>"
                            + "<td>" + Loading + "</td>";

                        Utils.calculateCurrentTimes(beforeYear,beforeMonth, registYear,registMonth,registDay, flagDate)
                            .then(({beforeMonthTimes, currentMonthTimes}) => {
                                const monthText = currentMonthTimes%12 < 10 ? "0"+currentMonthTimes%12 : currentMonthTimes%12+"";
                                const excelMonthText = beforeMonthTimes%12 < 10 ? "0"+beforeMonthTimes%12 : beforeMonthTimes%12+"";
                                const totalMonthText = (beforeMonthTimes + currentMonthTimes)%12 < 10 ? "0"+(beforeMonthTimes + currentMonthTimes)%12 : (beforeMonthTimes + currentMonthTimes)%12+""
                                const registMonthText = registMonth < 10 ? "0"+registMonth : registMonth+"";
                                const registDayText = registDay  < 10 ? "0"+registDay : registDay+"";

                                trs[j].innerHTML = "<td>" + trs[j].dataset.username + "</td>"
                                    + "<td>" + parseInt(currentMonthTimes / 12) + "년 " + monthText + "월" + "</td>"
                                    + "<td>" + parseInt((beforeMonthTimes + currentMonthTimes) / 12) + "년 " + totalMonthText + "월" + "</td>"
                                    + "<td>" + parseInt((parseInt(currentMonthTimes / 12) - 1) / 2)  + "일" + "</td>"
                                    + "<td>" + registYear + "-" + registMonthText + "-" + registDayText + "</td>";

                                excelTrs[j].innerHTML = "<td>" + trs[j].dataset.username + "</td>"
                                    + "<td>" + parseInt(beforeMonthTimes / 12) + "년 " + excelMonthText + "월" + "</td>"
                                    + "<td>" + parseInt(currentMonthTimes / 12) + "년 " + monthText + "월" + "</td>"
                                    + "<td>" + parseInt((beforeMonthTimes + currentMonthTimes) / 12) + "년 " + totalMonthText + "월" + "</td>"
                                    + "<td>" + parseInt((parseInt(currentMonthTimes / 12) - 1) / 2)  + "일" + "</td>"
                                    + "<td>" + "</td>"
                                    + "<td>" + registYear + "-" + registMonthText + "-" + registDayText + "</td>";
                            });
                        trs[j].style.display = "none";
                    }
                    for(let i = (paginationIndex - 1)*10; i<trs.length && i<paginationIndex*10; i++) {
                        trs[i].style.display = "table-row";
                    }
                }

                flagDateInput.addEventListener('input', () => {
                    tableRender()
                })
                tableRender();


                const paginationBtns = document.querySelector("#modalTotal").querySelector(".pagination").getElementsByClassName("paginationBtn");
                setPageNum();
                function setPageNum() {
                    for(let i = -2; i< 3; i++) {
                        if(paginationIndex + i >= 1 && paginationIndex + i - 1 <= trs.length / 10) {
                            paginationBtns[i+4].innerText = paginationIndex + i;
                        } else {
                            paginationBtns[i+4].innerText = "";
                        }
                    }
                }
                paginationBtns[0].addEventListener('click', () => {
                    paginationIndex = 1;
                })
                paginationBtns[1].addEventListener('click', () => {
                    if(paginationIndex - 1 > 0) {
                        paginationIndex -= 1;
                    }
                })
                paginationBtns[7].addEventListener('click', () => {
                    if(paginationIndex + 1 <= parseInt(trs.length / 10) + 1){
                        paginationIndex += 1;
                    }
                })
                paginationBtns[8].addEventListener('click', () => {
                    paginationIndex = parseInt(trs.length / 10) + 1;
                })
                for(let i = 0; i <paginationBtns.length; i++) {
                    paginationBtns[i].addEventListener('click', (e) => {
                        if(i >= 2 && i<=6 && e.currentTarget.innerText != "") {
                            paginationIndex = parseInt(e.currentTarget.innerText);
                        }
                        setPageNum();
                        for(let j = 0; j <trs.length; j++) {
                            trs[j].style.display = "none";
                        }

                        for(let i = (paginationIndex - 1)*10; i<trs.length && i<paginationIndex*10; i++) {
                            trs[i].style.display = "table-row";
                        }
                    })
                }

                var excelHandler = {
                    getExcelFileName : function(){
                        return '근속연수.xlsx';	//파일명
                    },
                    getSheetName : function(){
                        return 'NEOTEK';	//시트명
                    },
                    getExcelData : function(){
                        return document.getElementById('excelTable'); 	//TABLE id
                    },
                    getWorksheet : function(){
                        return XLSX.utils.table_to_sheet(this.getExcelData());
                    }
                }

                function s2ab(s) {
                    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
                    var view = new Uint8Array(buf);  //create uint8array as viewer
                    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
                    return buf;
                }

                function exportExcel() {
                    var wb = XLSX.utils.book_new();
                    var newWorksheet = excelHandler.getWorksheet();
                    XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());
                    var wbout = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});
                    saveAs(new Blob([s2ab(wbout)],{type:"application/octet-stream"}), excelHandler.getExcelFileName());
                }

                const excelDownloadBtn = document.getElementById("exceldownload");

                excelDownloadBtn.addEventListener('click', exportExcel);
            })

            let usersPaginationIndex = 1;
            window.addEventListener('DOMContentLoaded', () => {
                const paginationBox = document.querySelector(".table_wrapper").querySelector(".pagination");
                const paginationBtns = paginationBox.getElementsByClassName("paginationBtn");
                let trs = document.querySelector(".table_wrapper").querySelector("tbody").querySelectorAll("tr.active");

                setPageNum();


                function setPageNum() {
                    for(let i = -2; i< 3; i++) {
                        if(usersPaginationIndex + i >= 1 && usersPaginationIndex + i - 1 <= trs.length / 10) {
                            paginationBtns[i+4].innerText = usersPaginationIndex + i;
                        } else {
                            paginationBtns[i+4].innerText = "";
                        }
                    }

                    for(let j = 0; j <trs.length; j++) {
                        trs[j].style.display = "none";
                    }

                    for(let i = (usersPaginationIndex - 1)*10; i<trs.length && i<usersPaginationIndex*10; i++) {
                        trs[i].style.display = "table-row";
                    }
                }
                paginationBtns[0].addEventListener('click', () => {
                    usersPaginationIndex = 1;
                })
                paginationBtns[1].addEventListener('click', () => {
                    if(usersPaginationIndex - 1 > 0) {
                        usersPaginationIndex -= 1;
                    }
                })
                paginationBtns[7].addEventListener('click', () => {
                    if(usersPaginationIndex + 1 <=  parseInt(trs.length / 10) + 1){
                        usersPaginationIndex += 1;
                    }
                })
                paginationBtns[8].addEventListener('click', () => {
                    usersPaginationIndex = parseInt(trs.length / 10) + 1;
                })
                for(let i = 0; i <paginationBtns.length; i++) {
                    paginationBtns[i].addEventListener('click', (e) => {
                        if(i >= 2 && i<=6 && e.currentTarget.innerText != "") {
                            usersPaginationIndex = parseInt(e.currentTarget.innerText);
                        }
                        setPageNum();
                    })
                }

                const search = document.getElementById("tableSearch");
                search.addEventListener('submit', (e) => {
                    e.preventDefault();
                    const searchValue = search.querySelector('input').value;
                    const searchtrs = document.querySelector(".table_wrapper").querySelector("tbody").querySelectorAll("tr");
                    console.log(searchtrs);

                    for (let i = 0; i<searchtrs.length; i++) {
                        if (searchtrs[i].querySelector('td').innerText.includes(searchValue)) {
                            searchtrs[i].style.display = "table-row";
                            searchtrs[i].className = "active";
                        } else {
                            searchtrs[i].style.display = "none";
                            searchtrs[i].className = "non_active";
                        }
                    }

                    trs = document.querySelector(".table_wrapper").querySelector("tbody").querySelectorAll(".active");
                    console.log(trs);
                    setPageNum();
                })
            })
        </script>
    </jsp:attribute>
    <jsp:body>
        <main>
            <div class="headerContainer">
                <span class="title">회원 관리</span>
                <a id="openTotal"><span>근속 연수 다운로드</span></a>
            </div>
            <div class="table_wrapper">
                <table class="usersTable">
                    <thead>
                    <tr>
                        <th>이름</th>
                        <th>소속 / 직책</th>
                        <th>권한</th>
                        <th>총 연휴</th>
                        <th>등록 날짜</th>
                        <th>
                            <form id="tableSearch">
                                <input type="text" />
                                <input type="submit" value="검색"/>
                            </form>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach begin="0" step="1" end="${requestScope.users.size() - 1}" var="userIdx">
                        <tr class="active">
                            <td>${requestScope.users.get(userIdx).name}</td>
                            <td>${requestScope.users.get(userIdx).department}/${requestScope.users.get(userIdx).role}</td>
                            <td>${requestScope.users.get(userIdx).admin_role}</td>
                            <td>
                            <c:if test="${requestScope.users.get(userIdx).admin_role != 'root'}">
                                <c:choose>
                                    <c:when test="${requestScope.users.get(userIdx).totalLeaves == -1}">
                                        <span data-userNo="${requestScope.users.get(userIdx).user_no}" class="small-button registBtn">등록하기</span>
                                    </c:when>
                                    <c:otherwise>
                                        ${requestScope.users.get(userIdx).totalLeaves}일 <span data-userNo="${requestScope.users.get(userIdx).user_no}" class="small-button editBtn">수정</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            </td>
                            <td>${requestScope.users.get(userIdx).regist_date}</td>
                            <td>
                                <c:if test="${requestScope.users.get(userIdx).admin_role != 'root'}">
                                    <c:choose>
                                        <c:when test="${requestScope.users.get(userIdx).isdelete == 1}">
                                            <button class="small-button restore-button" data-id="${requestScope.users.get(userIdx).user_no}" >복구</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="small-button delete-button" data-id="${requestScope.users.get(userIdx).user_no}" >삭제</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="pagination">
                    <div class="paginationBtn"><<</div>
                    <div class="paginationBtn"><</div>
                    <div class="paginationBtn"></div>
                    <div class="paginationBtn"></div>
                    <div class="paginationBtn"></div>
                    <div class="paginationBtn"></div>
                    <div class="paginationBtn"></div>
                    <div class="paginationBtn">></div>
                    <div class="paginationBtn">>></div>
                </div>

            </div>
        </main>


        <t:modal>
        <form action="/calcLeaves" method="post" id="modalRegist">
            <input type="text" name="user_no" id="user_no"/>
            <span class="header">총 연휴 등록하기</span>

            <div>
                <span class="inputTitle">이전 직장</span>
                <div class="rowContent">
                    <div class="inputContainer">
                        <label for="year">년</label>
                        <select name="year" id="year" required>
                            <c:forEach begin="0" end="36" step="1" var="yearIdx">
                                <option value="${yearIdx}">${yearIdx}년</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="inputContainer">
                        <label for="month">월</label>
                        <select name="month" id="month">
                            <c:forEach begin="0" end="11" step="1" var="monthIdx">
                                <option value="${monthIdx}">${monthIdx}월</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
            <div class="inputContainer">
                <span class="inputTitle" >네오텍</span>
                <label for="enter_date">입사 일자</label>
                <input type="date" name="enter_date" id="enter_date" required/>
            </div>
            <div class="before calcContainer">
                <div>
                    <span class="title">네오텍</span>
                    <span class="flag">(현재 일 기준)</span>
                </div>
                <span class="calcResult">  년   월</span>
                </div>
                <div class="current calcContainer">
                    <div>
                        <span class="title">총 근무 연수</span>
                        <span class="flag">(현재 일 기준)</span>
                </div>
                <span class="calcResult">  년   월</span>
            </div>
            <div class="leavesAdd calcContainer">
                <div>
                    <span class="title">연휴 가산</span>
                    <span class="flag timeflag"></span>
                </div>
                <span class="calcResult" id="calcResult"> 일</span>
            </div>
            <span class="serverMessage">${requestScope.message}</span>
            <input type="submit" value="휴가 신청"/>
        </form>

        <div id="modalTotal">
            <div class="header">
                <span>근속 연수</span>
                <div class="rightContent">
                    <label>기준 일</label>
                    <input type="date" id="flagDate" value="2023-12-31"/>
                    <svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 512 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M128 0C92.7 0 64 28.7 64 64v96h64V64H354.7L384 93.3V160h64V93.3c0-17-6.7-33.3-18.7-45.3L400 18.7C388 6.7 371.7 0 354.7 0H128zM384 352v32 64H128V384 368 352H384zm64 32h32c17.7 0 32-14.3 32-32V256c0-35.3-28.7-64-64-64H64c-35.3 0-64 28.7-64 64v96c0 17.7 14.3 32 32 32H64v64c0 35.3 28.7 64 64 64H384c35.3 0 64-28.7 64-64V384zM432 248a24 24 0 1 1 0 48 24 24 0 1 1 0-48z" id="exceldownload"/></svg>
                </div>
            </div>
            <table id="totalTable">
                <thead>
                <tr>
                    <th>이름</th>
                    <th>네오텍</th>
                    <th>총 근무연수</th>
                    <th>연휴 가산</th>
                    <th>입사일</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach begin="0" step="1" end="${requestScope.users.size() - 1}" var="userIdx">
                    <c:if test="${requestScope.users.get(userIdx).isdelete == 0 && requestScope.users.get(userIdx).admin_role != 'root'}">
                        <tr class="tr" data-beforedate="${requestScope.users.get(userIdx).before_date}" data-enterdate="${requestScope.users.get(userIdx).enter_date}" data-username="${requestScope.users.get(userIdx).name}"></tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
            <table id="excelTable">
            <thead>
            <tr>
                <th>이름</th>
                <th>이전 직장</th>
                <th>네오텍</th>
                <th>총 근무연수</th>
                <th>연휴 가산</th>
                <th>진급 대상</th>
                <th>입사일</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach begin="0" step="1" end="${requestScope.users.size() - 1}" var="userIdx">
                <c:if test="${requestScope.users.get(userIdx).isdelete == 0 && requestScope.users.get(userIdx).admin_role != 'root'}">
                    <tr class="tr" data-beforedate="${requestScope.users.get(userIdx).before_date}" data-enterdate="${requestScope.users.get(userIdx).enter_date}" data-username="${requestScope.users.get(userIdx).name}"></tr>
                </c:if>
            </c:forEach>
            </tbody>
        </table>
            <div class="pagination">
                <div class="paginationBtn"><<</div>
                <div class="paginationBtn"><</div>
                <div class="paginationBtn"></div>
                <div class="paginationBtn"></div>
                <div class="paginationBtn"></div>
                <div class="paginationBtn"></div>
                <div class="paginationBtn"></div>
                <div class="paginationBtn">></div>
                <div class="paginationBtn">>></div>
            </div>
        </div>
    </t:modal>
    </jsp:body>
</t:layout>