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
           showTranChart();
       })
        function showTranChart() {
            $.ajax({
                url : "workbench/chart/transaction/showTranChart.do",
                type : "get",
                dataType : "json",
                success : function (data) {
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    option = {
                        title: {
                            text: '阶段条数统计图',
                            subtext: 'Fake Data',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left'
                        },
                        series: [
                            {
                                name: '阶段条数',
                                type: 'pie',
                                radius: '50%',
                                data:
                                    data
                                ,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
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
    <div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>
