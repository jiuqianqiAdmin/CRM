<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--jstl标签库一般用来遍历-->
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<base href="<%=basePath%>">
<html>
<head>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		//为删除交易按钮绑定事件
		$("#deleteTranBtn").click(function () {
			var $qx=$("input[name=xz]:checked")
			if($qx.length==0){
				alert("请选择要删除的线索")
			}else {
				if(confirm("确定删除所选线索吗？")){
					var param="";
					for (var i=0;i<$qx.length;i++){
						param+="id="+$($qx[i]).val();
						if(i<$qx.length-1){
							param+="&";
						}
					}
					$.ajax({
						url : "workbench/transaction/deleteTranById.do",
						data:param,
						type : "post",
						dataType : "json",
						success : function (data) {
							if(data.success){
								pageList(1,$("#tranPage").bs_pagination('getOption','rowsPerPage'));
							}else {
								alert("删除交易失败")
							}
						}
					})
				}

			}
		})
		//查询交易按钮绑定事件
		  $("#searchTranBtn").click(function () {
	        $("#hidden-name").val($.trim($("#search-name").val()))
	        $("#hidden-stage").val($.trim($("#search-stage").val()))
	        $("#hidden-source").val($.trim($("#search-source").val()))
	        $("#hidden-contactsName").val($.trim($("#search-contactsName").val()))
	        $("#hidden-customerName").val($.trim($("#search-customerName").val()))
	        $("#hidden-ownerName").val($.trim($("#search-ownerName").val()))
	        $("#hidden-type").val($.trim($("#search-type").val()))
			pageList(1,2)
		})
		pageList(1,2)
		//全选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#tranBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		//为修改线索按钮绑定事件并展现数据
		$("#editBtn").click(function () {
			var $xz=$("input[name=xz]:checked")
			var tranId=$xz.val();
			var activityName=$("#a"+tranId).val()
			var contactsName=$("#con"+tranId).html()
			var customerName=$("#cus"+tranId).html()
			if($xz.length==0){
				alert("请选择要修改的市场活动");
			}else if($xz.length>1){
				alert("一次只能修改一条修改记录");
			}else {
				window.location.href="workbench/transaction/edit.jsp?tranId="+tranId+"&activityName="+activityName+"&contactsName="+contactsName+"&customerName="+customerName;
			}
		})
	});
	//刷新交易记录
	function pageList(pageNo,pageSize) {
		//每次刷新取消全选框的选择
		$("#qx").prop("checked",false);
		//从隐藏域中取出点击分页组件前的值
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-contactsName").val($.trim($("#hidden-contactsName").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));
		$("#search-ownerName").val($.trim($("#hidden-ownerName").val()));
		$("#search-type").val($.trim($("#hidden-type").val()));
		$.ajax({
			url : "workbench/transaction/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"ownerName":$.trim($("#search-ownerName").val()),
				"name":$.trim($("#search-name").val()),
				"customerName":$.trim($("#search-customerName").val()),
				"stage":$.trim($("#search-stage").val()),
				"type":$.trim($("#search-type").val()),
				"source":$.trim($("#search-source").val()),
				"contactsName":$.trim($("#search-contactsName").val())
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				var html="";
				$.each(data.dataList,function (i,n) {
				    html+='<tr>';
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td> ';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.customerId+'-'+n.name+'</a></td>';
					html+='<td id="cus'+n.id+'">'+n.customerId+'</td>';
					html+='<td>'+n.stage+'</td>';
					html+='<td>'+n.type+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td id="con'+n.id+'">'+n.contactsId+'</td>';
					html+='<input type="hidden" id="a'+n.id+'" value="'+n.activityId+'">'
					html+='</tr>';
				})
				$("#tranBody").html(html);
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//分页
				$("#tranPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
</script>
</head>
<body>
<input type="hidden" id="hidden-ownerName">
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-customerName">
<input type="hidden" id="hidden-stage">
<input type="hidden" id="hidden-type">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-contactsName">
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-ownerName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
						  <c:forEach items="${stage}" var="s">
							  <option id="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
						  <c:forEach items="${transactionType}" var="s">
							  <option id="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="s">
							  <option id="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchTranBtn" >查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/getUserList.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage"></div>
			</div>
		</div>
	</div>
</body>
</html>