<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<base href="<%=basePath%>">
<html>
<head>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script src="ECharts/echarts.min.js"></script>
    <script type="text/javascript">
       $(function () {
           showClueChart();
       })
        function showClueChart() {
            $.ajax({
                url : "workbench/chart/Clue/showClueChart.do",
                type : "get",
                dataType : "json",
                success : function (data) {
                    var arr=[]
                    var arr1=[]
                    $.each(data,function (i,n) {
                        arr.push(n.name)
                        arr1.push(n.value)
                    })
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '线索状态统计图'
                        },
                        tooltip: {},
                        legend: {
                            data: ['线索状态']
                        },
                        xAxis: {
                            data: arr
                        },
                        yAxis: {},
                        series: [
                            {
                                name: '线索状态',
                                type: 'bar',
                                data: arr1
                            }
                        ]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })
       }
    </script>
</head>
<body>
    <div id="main" style="width: 1000px;height:400px;"></div>
</body>
</html>
