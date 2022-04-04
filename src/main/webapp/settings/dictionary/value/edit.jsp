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
	<script type="text/javascript">
		$(function () {
			$("#updateDicValueBtn").click(function () {
				$.ajax({
					url : "settings/dicValue/updateDicValue.do",
					data:{
						"id":$.trim($("#hidden-dicValueId").val()),
						"value":$.trim($("#edit-dicValue").val()),
						"text":$.trim($("#edit-text").val()),
						"orderNo":$.trim($("#edit-orderNo").val()),
						"typeCode":$.trim($("#edit-dicTypeCode").val())
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if(data.success){
							window.location.href="settings/dictionary/value/index.jsp"
						}else {
							alert("修改失败,请重试")
						}
					}
			})
		})
			show();
		})
		function show() {
			$("#hidden-dicValueId").val("${dicValue.id}")
			$("#edit-dicValue").val("${dicValue.value}");
			$("#edit-text").val("${dicValue.text}");
			$("#edit-orderNo").val("${dicValue.orderNo}");
			$("#edit-dicTypeCode").val("${dicValue.typeCode}");
		}
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateDicValueBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
		<input type="hidden" id="hidden-dicValueId">
		<div class="form-group">
			<label for="edit-dicTypeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-dicTypeCode" style="width: 200%;">
					<option></option>
					<c:forEach items="${dicType}" var="a">
						<option value="${a.code}">${a.name}</option>
					</c:forEach>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-dicValue" style="width: 200%;" >
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-text" style="width: 200%;" >
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" >
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>