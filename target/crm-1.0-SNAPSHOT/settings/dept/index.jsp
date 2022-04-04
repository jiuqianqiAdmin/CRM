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
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>	<script type="text/javascript">
		$(function () {
			//为删除用户按钮绑定事件
			$("#deleteDeptBtn").click(function () {
				var $qx=$("input[name=xz]:checked")
				if($qx.length==0){
					alert("请选择要删除的部门")
				}else {
					if(confirm("确定删除所选部门吗？")){
						var param="";
						for (var i=0;i<$qx.length;i++){
							param+="id="+$($qx[i]).val();
							if(i<$qx.length-1){
								param+="&";
							}
						}
						$.ajax({
							url : "settings/dept/deleteDeptById.do",
							data:param,
							type : "post",
							dataType : "json",
							success : function (data) {
								if(data.success){
									pageList(1,$("#deptPage").bs_pagination('getOption','rowsPerPage'));

								}else {
									alert("删除部门失败")
								}
							}
						})
					}

				}
			})
			//为修改部门保存按钮绑定事件
			$("#updateDeptBtn").click(function () {
				$.ajax({
					url : "settings/dept/updateDept.do",
					data:{
						"id":$.trim($("#hidden-deptId").val()),
						"deptno":$.trim($("#edit-code").val()),
						"deptname":$.trim($("#edit-name").val()),
						"principal":$.trim($("#edit-manager").val()),
						"phone":$.trim($("#edit-phone").val()),
						"description":$.trim($("#edit-describe").val()),
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if(data.success){
							$("#editDeptModal").modal("hide");
							pageList($("#deptPage").bs_pagination('getOption', 'currentPage')
									,$("#deptPage").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert("修改失败请重试")
						}

					}
				})
			})
			//为修改部门按钮绑定事件并展现数据
			$("#editDeptBtn").click(function () {
				var $xz=$("input[name=xz]:checked")
				if($xz.length==0){
					alert("请选择要修改的部门");
				}else if($xz.length>1){
					alert("一次只能修改一条修改记录");
				}else {
					var id=$xz.val();
					$.ajax({
						url : "settings/dept/editDept.do",
						data:{
							"id":id
						},
						type : "get",
						dataType : "json",
						success : function (data) {
							$("#edit-code").val(data.deptno);
							$("#edit-name").val(data.deptname);
							$("#edit-manager").val(data.principal);
							$("#edit-phone").val(data.phone);
							$("#edit-describe").val(data.description);
							$("#hidden-deptId").val(data.id)
						}
					})
					$("#editDeptModal").modal("show")
				}
			});
			//保存部门按钮绑定事件
			$("#saveDeptBtn").click(function () {
				$.ajax({
					url : "settings/dept/saveDept.do",
					data:{
						"deptno":$.trim($("#create-code").val()),
						"deptname":$.trim($("#create-name").val()),
						"principal":$.trim($("#create-manager").val()),
						"phone":$.trim($("#create-phone").val()),
						"description":$.trim($("#create-describe").val()),
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						if(data.success){
							$("#createDeptModal").modal("hide");
							$("#createDeptModalFrom")[0].reset();
							pageList(1, $("#deptPage").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert("新增部门失败，请重试")
						}
					}
				})
			})
			//全选
			$("#qx").click(function () {
				$("input[name=xz]").prop("checked", this.checked);
			})
			$("#deptBody").on("click", $("input[name=xz]"), function () {
				$("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length)
			})
			pageList(1,10)
			//修改密码
			$("#updatePwdBtn").click(function () {
				if($.trim($("#oldPwd").val())==""){
					$("#msg").html("原密码密码不能为空");
				}else {
					var newPwd=$.trim($("#newPwd").val())
					var confirmPwd=$.trim($("#confirmPwd").val())
					if(newPwd==confirmPwd){

						$.ajax({
							url: "settings/user/updatePwd.do",
							data: {
								"id":"${User.id}",
								"oldPwd":$.trim($("#oldPwd").val()),
								"newPwd":newPwd
							},
							type: "post",
							dataType: "json",
							success: function (data) {
								if(data.success){
									$("#editPwdModal").modal("hide")
									window.location.href='login.jsp';
								}else {
									$("#msg").html("原密码密码错误");
								}

							}
						})
					}else {
						$("#msg").html("密码不一致");
					}

				}

		})
		})
		//刷新用户列表
		function pageList(pageNo,pageSize) {
			//每次刷新取消全选框的选择
			$("#qx").prop("checked", false);
			$.ajax({
				url: "settings/dept/pageList.do",
				data: {
					"pageNo": pageNo,
					"pageSize": pageSize,
				},
				type: "get",
				dataType: "json",
				success: function (data) {
					var html = "";
					$.each(data.dataList, function (i, n) {
					            html+='<tr>';
						        html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
								html+='<td>'+n.deptno+'</td>';
								html+='<td>'+n.deptname+'</td>';
								html+='<td>'+n.principal+'</td>';
								html+='<td>'+n.phone+'</td>';
								html+='<td>'+n.description+'</td>';
						        html+='</tr>';
					})
					$("#deptBody").html(html);
					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
					//分页
					$("#deptPage").bs_pagination({
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

	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>${User.name}</b><br><br>
						登录帐号：<b>${User.loginAct}</b><br><br>
						组织机构：<b>${User.deptno}</b><br><br>
						邮箱：<b>${User.email}</b><br><br>
						失效时间：<b>${User.expireTime}</b><br><br>
						允许访问IP：<b>${User.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
								<font color="red"><span id="msg" ></span></font>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="updatePwdBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.html';">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;九千七</span></div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> ${User.name} <span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="workbench/index.jsp"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
						<li><a href="settings/index.jsp"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 创建部门的模态窗口 -->
	<div class="modal fade" id="createDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-plus"></span> 新增部门</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createDeptModalFrom">
					
						<div class="form-group">
							<label for="create-code" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-code" style="width: 200%;" placeholder="编号不能为空，具有唯一性">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-manager" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-manager" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveDeptBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改部门的模态窗口 -->
	<div class="modal fade" id="editDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myeditModalLabel"><span class="glyphicon glyphicon-edit"></span> 编辑部门</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					<input type="hidden" id="hidden-deptId">
						<div class="form-group">
							<label for="edit-code" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-code" style="width: 200%;" placeholder="不能为空，具有唯一性">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-manager" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-manager" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateDeptBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div style="width: 95%">
		<div>
			<div style="position: relative; left: 30px; top: -10px;">
				<div class="page-header">
					<h3>部门列表</h3>
				</div>
			</div>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; top:-30px;">
			<div class="btn-group" style="position: relative; top: 18%;">
			  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createDeptModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
			  <button type="button" class="btn btn-default" id="editDeptBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			  <button type="button" class="btn btn-danger" id="deleteDeptBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>
		</div>
		<div style="position: relative; left: 30px; top: -10px;">
			<table class="table table-hover">
				<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="qx"/></td>
						<td>编号</td>
						<td>名称</td>
						<td>负责人</td>
						<td>电话</td>
						<td>描述</td>
					</tr>
				</thead>
				<tbody id="deptBody">
					<%--<tr class="active">
						<td><input type="checkbox" /></td>
						<td>1110</td>
						<td>财务部</td>
						<td>张飞</td>
						<td>010-84846005</td>
						<td>description info</td>
					</tr>
					<tr>
						<td><input type="checkbox" /></td>
						<td>1120</td>
						<td>销售部</td>
						<td>关羽</td>
						<td>010-84846006</td>
						<td>description info</td>
					</tr>--%>
				</tbody>
			</table>
		</div>
		
		<div style="height: 50px; position: relative;top: 0px; left:30px;">
			<div id="deptPage"></div>
		</div>
			
	</div>
	
</body>
</html>