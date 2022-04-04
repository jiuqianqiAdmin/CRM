<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--jstl标签库一般用来遍历-->
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
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

	$(function(){
		//为删除联系人按钮绑定事件
		$("#deleteBtn").click(function () {
			var $qx=$("input[name=xz]:checked")
			if($qx.length==0){
				alert("请选择要删除的")
			}else {
				if(confirm("确定删除所选联系人吗？")){
					var param="";
					for (var i=0;i<$qx.length;i++){
						param+="id="+$($qx[i]).val();
						if(i<$qx.length-1){
							param+="&";
						}
					}
					$.ajax({
						url : "workbench/contacts/delete.do",
						data:param,
						type : "post",
						dataType : "json",
						success : function (data) {
							if(data.success){
								pageList(1,$("#contactsPage").bs_pagination('getOption','rowsPerPage'));
							}else {
								alert("删除联系人失败")
							}
						}
					})
				}

			}
		})
		//为修改页面的提交按钮绑定事件
		$("#updateBtn").click(function () {
			$.ajax({
				url : "workbench/contacts/updateContacts.do",
				data:{
					"id":$.trim($("#hidden-contactsId").val()),
					"owner":$.trim($("#edit-contactsOwner").val()),
					"source":$.trim($("#edit-clueSource1").val()),
					"customerName":$.trim($("#edit-customerName").val()),
					"fullname":$.trim($("#edit-surname").val()),
					"appellation":$.trim($("#edit-call").val()),
					"email":$.trim($("#edit-email").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"job":$.trim($("#edit-job").val()),
					"birth":$.trim($("#edit-birth").val()),
					"description":$.trim($("#edit-describe").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address2").val()),
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if(data.success){
						$("#editContactsModal").modal("hide");
						pageList($("#contactsPage").bs_pagination('getOption', 'currentPage')
								,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert("修改失败")
					}
				}
			})
		})
		//全选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#contactsBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		//修改按钮绑定事件
		$("#editBtn").click(function () {
			var $xz=$("input[name=xz]:checked")
			if($xz.length==0){
				alert("请选择要修改的联系人");
			}else if($xz.length>1){
				alert("一次只能修改一条修改记录");
			}else {
				var id=$xz.val();
				$.ajax({
					url : "workbench/contacts/getUserListAndContacts.do",
					data:{
						"id":id
					},
					type : "get",
					dataType : "json",

					success : function (data) {
						var html="<option></option>";
						$.each(data.list,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-contactsOwner").html(html);
						$("#edit-contactsOwner").val(data.contacts.owner);
						$("#hidden-contactsId").val(id)
						$("#edit-customerName").val(data.contacts.customerId);
						$("#edit-mphone").val(data.contacts.mphone);
						$("#edit-website").val(data.contacts.website);
						$("#edit-address2").val(data.contacts.address);
						$("#edit-nextContactTime").val(data.contacts.nextContactTime);
						$("#edit-contactSummary").val(data.contacts.contactSummary);
						$("#edit-describe").val(data.contacts.description);
						$("#edit-clueSource1").val(data.contacts.source);
						$("#edit-job").val(data.contacts.job);
						$("#edit-birth").val(data.contacts.birth);
						$("#edit-surname").val(data.contacts.fullname);
						$("#edit-call").val(data.contacts.appellation);
						$("#edit-email").val(data.contacts.email);

					}
				})
				$("#editContactsModal").modal("show")
			}
		})
		//日历插件
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
		//自动补全
		$("#create-customerName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/contacts/getCustomerName.do",
						{ "name" : query },
						function (data) {
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});
		$("#edit-customerName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/contacts/getCustomerName.do",
						{ "name" : query },
						function (data) {
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});
		//添加联系人按钮绑定事件
		$("#saveBtn").click(function () {
			$.ajax({
				url : "workbench/contacts/saveContacts.do",
				data:{

					"owner":$.trim($("#create-contactsOwner").val()),
					"source":$.trim($("#create-clueSource").val()),
					"customerName":$.trim($("#create-customerName").val()),
					"fullname":$.trim($("#create-surname").val()),
					"appellation":$.trim($("#create-call").val()),
					"email":$.trim($("#create-email").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"job":$.trim($("#create-job").val()),
					"birth":$.trim($("#create-birth").val()),
					"description":$.trim($("#create-describe").val()),
					"contactSummary":$.trim($("#create-contactSummary1").val()),
					"nextContactTime":$.trim($("#create-nextContactTime1").val()),
					"address":$.trim($("#create-address").val()),

				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if(data.success){
						$("#createContactsModal").modal("hide");
						$("#createContactsFrom")[0].reset();
						pageList(1,$("#contactsPage").bs_pagination('getOption','rowsPerPage'));
					}else {
						alert("添加失败")
					}
				}
			})
		})
		//为创建按钮打开模态窗口获取用户列表绑定事件
		$("#addBtn").click(function () {
			$.ajax({
				url : "workbench/contacts/getUserList.do",
				data:{
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					var html = "<option></option>";
					$.each(data, function (i, n) {
						html += "<option value='" + n.id + "'>" + n.name + "</option>"
					})
					$("#create-contactsOwner").html(html);
					//打开模态窗口
					$("#createContactsModal").modal("show");
					var id="${User.id}"
					$("#create-contactsOwner").val(id);
				}
			})
		})
		//为搜索按钮绑定事件
		$("#pageListBtn").click(function () {
			$("#hidden-name").val($("#search-name").val());
			$("#hidden-source").val($("#search-source").val());
			$("#hidden-customerName").val($("#search-customerName").val());
			$("#hidden-ownerName").val($("#search-ownerName").val());
			pageList(1,2)
		})
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		pageList(1,2)
	});
	function pageList(pageNo,pageSize) {
		//每次刷新取消全选框的选择
		//$("#qx").prop("checked",false);
		//从隐藏域中取出点击分页组件前的值
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));
		$("#search-ownerName").val($.trim($("#hidden-ownerName").val()));

		$.ajax({
			url : "workbench/contacts/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"source":$.trim($("#search-source").val()),
				"customerName":$.trim($("#search-customerName").val()),
				"ownerName":$.trim($("#search-ownerName").val())
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				var html="";
				$.each(data.dataList,function (i,n) {
				    html+='<tr class="active">';
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
					html+='<td>'+n.customerId+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td>'+n.birth+'</td>';
					html+='</tr>';
				})
				$("#contactsBody").html(html);
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//分页
				$("#contactsPage").bs_pagination({
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
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-ownerName">
<input type="hidden" id="hidden-customerName">
<input type="hidden" id="hidden-source">

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createContactsFrom">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">

								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
									<option></option>
									<c:forEach items="${source}" var="c">
										<option id="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option id="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					<input type="hidden" id="hidden-contactsId">
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">

								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
								  <option></option>
									<c:forEach items="${source}" var="c">
										<option id="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">

							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option id="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="c">
							  <option id="${c.value}">${c.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="pageListBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="contactsPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>