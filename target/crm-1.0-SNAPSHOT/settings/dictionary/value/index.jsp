<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<base href="<%=basePath%>">
<html>
<head>
<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript">
		$(function () {
			//为删除数据字典类型按钮绑定事件
			$("#deleteDicValueBtn").click(function () {
				var $qx=$("input[name=xz]:checked")
				if($qx.length==0){
					alert("请选择要数据字典值")
				}else {
					if(confirm("确定删除所选数据字典值吗？")){
						var param="";
						for (var i=0;i<$qx.length;i++){
							param+="id="+$($qx[i]).val();
							if(i<$qx.length-1){
								param+="&";
							}
						}
						$.ajax({
							url : "settings/dicValue/deleteDicValue.do",
							data:param,
							type : "post",
							dataType : "json",
							success : function (data) {
								if(data.success){
									pageList(1,$("#dicValuePage").bs_pagination('getOption','rowsPerPage'));
								}else {
									alert("删除数据字典值失败，请重试")
								}
							}
						})
					}

				}
			})
			//为修改数据字典类型按钮绑定事件并展现数据
			$("#editDicValueBtn").click(function () {
				var $xz=$("input[name=xz]:checked")
				if($xz.length==0){
					alert("请选择要修改的数据字典类型");
				}else if($xz.length>1){
					alert("一次只能修改一条修改记录");
				}else {
					var id=$xz.val();
					window.location.href="settings/dicValue/edit.do?id="+id;
				}
			})
			pageList(1,10)
			//全选
			$("#qx").click(function () {
				$("input[name=xz]").prop("checked",this.checked);
			})
			$("#dicValueBody").on("click",$("input[name=xz]"),function () {
				$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
			})

		})
		//刷新数据字典值列表
		function pageList(pageNo,pageSize) {
			$.ajax({
				url: "settings/dicValue/pageList.do",
				data: {
					"pageNo": pageNo,
					"pageSize": pageSize,
				},
				type: "get",
				dataType: "json",
				success: function (data) {
					var html = "";
					$.each(data.dataList, function (i, n) {
					            html+='<tr class="active">';
								html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
								html+='<td>'+i+'</td>';
								html+='<td>'+n.value+'</td>';
								html+='<td>'+n.text+'</td>';
								html+='<td>'+n.orderNo+'</td>';
								html+='<td>'+n.typeCode+'</td>';
								html+='</tr>';
					})
					$("#dicValueBody").html(html);
					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
					//分页
					$("#dicValuePage").bs_pagination({
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

						onChangePage: function (event, data) {
							pageList(data.currentPage, data.rowsPerPage);
						}
					});
				}
			})
		}
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/save.jsp'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editDicValueBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteDicValueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"/></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="dicValueBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>m</td>
					<td>男</td>
					<td>1</td>
					<td>sex</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td>f</td>
					<td>女</td>
					<td>2</td>
					<td>sex</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>3</td>
					<td>1</td>
					<td>一级部门</td>
					<td>1</td>
					<td>orgType</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>4</td>
					<td>2</td>
					<td>二级部门</td>
					<td>2</td>
					<td>orgType</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>5</td>
					<td>3</td>
					<td>三级部门</td>
					<td>3</td>
					<td>orgType</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div id="dicValuePage"></div>
	</div>
</body>
</html>