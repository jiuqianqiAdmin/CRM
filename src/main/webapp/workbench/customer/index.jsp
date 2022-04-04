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

	$(function(){
		//全选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#customerBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		pageList(1,2)
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		//时间日历
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		//为创建按钮绑定事件
		$("#addBtn").click(function () {
			$.ajax({
				url : "workbench/customer/getUserList.do",
				type : "get",
				dataType : "json",
				success : function (data) {

					var html="<option></option>";
					$.each(data,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-customerOwner").html(html);
					//打开模态窗口
					$("#createCustomerModal").modal("show");
					var id="${User.id}"
					$("#create-customerOwner").val(id);
				}
			})
		})
		//为创建客户中的保存按钮绑定事件
		$("#createCustomerBtn").click(function () {
			$.ajax({
				url : "workbench/customer/saveCustomer.do",
				data:{
					"owner":$.trim($("#create-customerOwner").val()),
					"name":$.trim($("#create-customerName").val()),
					"website":$.trim($("#create-website").val()),
					"phone":$.trim($("#create-phone").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"description":$.trim($("#create-describe").val()),
					"address":$.trim($("#create-address1").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if(data.success){
						$("#createCustomerModal").modal("hide");
						$("#createCustomerFrom")[0].reset();
						pageList(1,$("#customerPage").bs_pagination('getOption','rowsPerPage'));
					}else {
						alert("添加失败")
					}
				}
			})
		})
		//查询按钮绑定事件
		$("#searchCustomerBtn").click(function () {
			$("#hidden-name").val($.trim($("#name").val()));
			$("#hidden-owner").val($.trim($("#owner").val()));
			$("#hidden-website").val($.trim($("#website").val()));
			$("#hidden-phone").val($.trim($("#phone").val()));
			pageList(1,2)
		})
		//为修改线索按钮绑定事件并展现数据
		$("#editBtn").click(function () {
			var $xz=$("input[name=xz]:checked")
			if($xz.length==0){
				alert("请选择要修改的市场活动");
			}else if($xz.length>1){
				alert("一次只能修改一条修改记录");
			}else {
				var id=$xz.val();
				$.ajax({
					url : "workbench/customer/getUserListAndCustomer.do",
					data:{
						"id":id
					},
					type : "get",
					dataType : "json",

					success : function (data) {
						var html="";
						$.each(data.list,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-customerOwner").html(html);
						$("#edit-customerOwner").val(data.customer.owner);
						$("#hidden-customerId").val(data.customer.id)
						$("#edit-customerName").val(data.customer.name);
						$("#edit-phone").val(data.customer.phone);
						$("#edit-website").val(data.customer.website);
						$("#edit-address").val(data.customer.address);
						$("#edit-nextContactTime").val(data.customer.nextContactTime);
						$("#edit-contactSummary").val(data.customer.contactSummary);
						$("#edit-describe").val(data.customer.description);
					}
				})
				$("#editCustomerModal").modal("show")
			}
		});
		//为修改用户页面的提交按钮绑定事件
		$("#updateBtn").click(function () {
			$.ajax({
				url : "workbench/customer/updateCustomer.do",
				data:{
					"id":$.trim($("#hidden-customerId").val()),
					"owner":$.trim($("#edit-customerOwner").val()),
					"name":$.trim($("#edit-customerName").val()),
					"website":$.trim($("#edit-website").val()),
					"phone":$.trim($("#edit-phone").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"description":$.trim($("#edit-describe").val()),
					"address":$.trim($("#edit-address").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if(data.success){
						$("#editCustomerModal").modal("hide");
						pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
								,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert("修改失败")
					}
				}
			})
		})
		//为删除用户按钮绑定事件
		$("#deleteCustomerBtn").click(function () {
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
						url : "workbench/customer/deleteCustomerById.do",
						data:param,
						type : "post",
						dataType : "json",
						success : function (data) {
							if(data.success){
								pageList(1,$("#customerPage").bs_pagination('getOption','rowsPerPage'));

							}else {
								alert("删除线索失败")
							}
						}
					})
				}

			}
		})
	});

	//刷新市场活动
	function pageList(pageNo,pageSize) {
		//每次刷新取消全选框的选择
		$("#qx").prop("checked",false);
		//从隐藏域中取出点击分页组件前的值
		$("#owner").val($.trim($("#hidden-owner").val()))
		$("#name").val($.trim($("#hidden-name").val()))
		$("#phone").val($.trim($("#hidden-phone").val()))
		$("#website").val($.trim($("#hidden-website").val()))
		$.ajax({
			url: "workbench/customer/pageList.do",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"owner": $.trim($("#owner").val()),
				"name": $.trim($("#name").val()),
				"website": $.trim($("#website").val()),
				"phone": $.trim($("#phone").val()),
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data.dataList, function (i, n) {
					html += '<tr>'
					html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">' + n.name + '</a></td>'
					html += '<td>' + n.owner + '</td>'
					html += '<td>' + n.phone + '</td>'
					html += '<td>' + n.website + '</td>'
					html += '</tr>'
				})
				$("#customerBody").html(html);
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
				//分页
				$("#customerPage").bs_pagination({
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

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createCustomerFrom">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="createCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					<input type="hidden" id="hidden-customerId">
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">

								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
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
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
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
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <input type="hidden" id="hidden-name">
				  <input type="hidden" id="hidden-owner">
				  <input type="hidden" id="hidden-phone">
				  <input type="hidden" id="hidden-website">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="website" >
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchCustomerBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="customerPage"></div>
			</div>
		</div>
	</div>
</body>
</html>