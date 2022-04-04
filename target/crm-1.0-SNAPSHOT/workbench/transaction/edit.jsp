<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %><%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	Map<String,String> map=(Map<String, String>) application.getAttribute("map1");
	Set<String> set=map.keySet();%>
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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">
	$(function () {

		//自动补全插件
		$("#edit-accountName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/transaction/getCustomerName.do",
						{ "name" : query },
						function (data) {
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});
		//为查询联系人的搜索框绑定回车事件
		$("#bname").keydown(function (event) {
			//如果取得的键位的码值为13，表示敲的是回车键
			if(event.keyCode==13){
				$.ajax({
					url: "workbench/transaction/searchContactsBYName.do",
					data: {
						"name":$.trim($("#bname").val())
					},
					type: "get",
					dataType: "json",
					success: function (data) {
						var html = "";
						$.each(data, function (i, n) {
							html+='<tr>';
							html+='<td><input type="radio" name="contacts" value="'+n.id+'"/></td>';
							html+='<td id="'+n.id+'">'+n.fullname+'</td>';
							html+='<td>'+n.email+'</td>';
							html+='<td>'+n.mphone+'</td>';
							html+='</tr>';
						})
						$("#contactsSearchBody").html(html);

					}
				})
				return false;
			}
		})
		$("#searchContactsBtn").click(function () {
			var $xz=$("input[name=contacts]:checked");
			var id=$xz.val();
			var name=$("#"+id).html();
			$("#edit-contactsName").val(name);
			$("#hidden-contactsId").val(id);
			$("#findContacts").modal("hide")
		})
		//为添加线索中的查询市场活动的搜索框绑定回车事件
		$("#aname").keydown(function (event) {
			//如果取得的键位的码值为13，表示敲的是回车键
			if(event.keyCode==13){
				$.ajax({
					url: "workbench/transaction/searchActivityBYName.do",
					data: {
						"name":$.trim($("#aname").val())
					},
					type: "get",
					dataType: "json",
					success: function (data) {
						var html = "";
						$.each(data, function (i, n) {
							html+='<tr>';
							html+='<td><input type="radio" name="activityId" value="'+n.id+'"/></td>';
							html+='<td id="'+n.id+'">'+n.name+'</td>';
							html+='<td>'+n.startDate+'</td>';
							html+='<td>'+n.endDate+'</td>';
							html+='<td>'+n.owner+'</td>';
							html+='</tr>';
						})
						$("#activitySearchBody").html(html);
					}
				})
				return false;
			}
		})
		$("#searchActivityBtn").click(function () {
			var $xz=$("input[name=activityId]:checked");
			var id=$xz.val();
			var name=$("#"+id).html();
			$("#edit-activitySrc").val(name);
			$("#hidden-activityId").val(id);
			$("#findMarketActivity").modal("hide")
		})
		//为更新交易页面中的更新按钮绑定事件
		$("#updateTranBtn").click(function () {
			$("#tranFrom").submit();
		})
		//随着选择阶段的改变改变可能性中的值
		$("#edit-transactionStage").change(function () {
			changeStage()
		})
		getUserListAndTran();

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		$(".time1").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

	})
	//随着选择阶段的改变改变可能性中的值
	function changeStage() {
		var json={
			<%
			for (String key:set){
				String value=map.get(key);
		    %>
			"<%=key%>":<%=value%>,
			<%
			}
			%>
		}
		var stage=$("#edit-transactionStage").val();
		var possibility=json[stage]
		//alert(possibility);
		$("#edit-possibility").val(possibility);
	}
	function getQueryString(name) {
		var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i')
		var r = window.location.search.substr(1).match(reg)
		if (r != null) {
			return decodeURI(r[2])
		} else {
			return null
		}
	}

	function getUserListAndTran() {
		var tranId=getQueryString("tranId")
		var activityName=getQueryString("activityName")
		var contactsName=getQueryString("contactsName")
		var customerName=getQueryString("customerName")
		$.ajax({
			url : "workbench/transaction/getUserListAndTran.do",
			data:{
				"tranId":tranId
			},
			type : "get",
			dataType : "json",

			success : function (data) {
				var html="<option></option>";
				$.each(data.list,function (i,n) {
					html+="<option value='"+n.id+"'>"+n.name+"</option>";
				})
				$("#edit-transactionOwner").html(html)
				$("#edit-transactionOwner").val(data.t.owner)
				$("#edit-amountOfMoney").val(data.t.money)
				$("#edit-transactionName").val(data.t.name)
				$("#edit-expectedClosingDate").val(data.t.expectedDate)
				$("#edit-accountName").val(customerName)
				$("#edit-transactionStage").val(data.t.stage)
				$("#edit-transactionType").val(data.t.type)
				$("#edit-possibility").val(data.t.possibility)
				$("#edit-clueSource").val(data.t.source)
				$("#edit-activitySrc").val(activityName)
				$("#edit-contactsName").val(contactsName)
				$("#create-describe").val(data.t.description)
				$("#create-contactSummary").val(data.t.contactSummary)
				$("#create-nextContactTime").val(data.t.nextContactTime)
				$("#tranId").val(tranId)
				$("#hidden-contactsId").val(data.t.contactsId)
				$("#hidden-activityId").val(data.t.activityId);
				changeStage()
			}
		})
	}

</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="aname">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="searchActivityBtn">确定</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询" id="bname">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsSearchBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="searchContactsBtn">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateTranBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="tranFrom" method="post" action="workbench/transaction/update.do">
		<input type="hidden" name="id" id="tranId">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner" name="owner">
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" name="name">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-expectedClosingDate"name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-accountName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-transactionStage" name="stage">
			  	<option></option>
				  <c:forEach items="${stage}" var="s">
					  <option id="${s.value}">${s.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionType}" var="s">
						<option id="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource" name="source">
				  <option></option>
					<c:forEach items="${source}" var="s">
						<option id="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activitySrc">
				<input type="hidden" id="hidden-activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName">
				<input type="hidden" id="hidden-contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>