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
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<SCRIPT type="text/javascript">
	$(function () {
		$(".time").datetimepicker({
			minView: "month",
			language: 'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		//修改用户按钮绑定事件
	$("#editUserBtn").click(function () {
		$("#edit-lockStatus").val("${user.lockState}");
		$("#edit-dept").val("${user.deptno}");
		$("#edit-loginActNo").val("${user.loginAct}");
		$("#edit-username").val("${user.name}");
		$("#edit-expireTime").val("${user.expireTime}");
		$("#edit-allowIps").val("${user.allowIps}");
		$("#edit-email").val("${user.email}");
		$("#editUserModal").modal("show")
	})
		$("#updateUserBtn").click(function () {
			if($.trim($("#edit-loginPwd").val())==""&&$.trim($("#edit-confirmPwd").val())==""){
				alert("密码不能为空")
			}else {
				var newPwd = $.trim($("#edit-loginPwd").val())
				var confirmPwd = $.trim($("#edit-confirmPwd").val())
				if (newPwd == confirmPwd) {
					$.ajax({
						url: "settings/user/updateUser.do",
						data: {
							"id":"${user.id}",
							"loginAct": $.trim($("#edit-loginActNo").val()),
							"name": $.trim($("#edit-username").val()),
							"loginPwd": $.trim($("#edit-loginPwd").val()),
							"email": $.trim($("#edit-email").val()),
							"expireTime": $.trim($("#edit-expireTime").val()),
							"lockState": $.trim($("#edit-lockStatus").val()),
							"deptno": $.trim($("#edit-dept").val()),
							"allowIps": $.trim($("#edit-allowIps").val())

						},
						type: "get",
						dataType: "json",
						success: function (data) {
							if (data.success) {
								$("#editUserModal").modal("hide");
								window.location.href="settings/user/detail.do?id=${user.id}";
							} else {
								alert("修改失败，请重试")
							}

						}
					})
				} else {
					alert("密码不一致")
				}
			}
		})
})
	var setting = {
		data: {
			simpleData: {
				enable: true
			}
		}
	};

	
	$(document).ready(function(){
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
	});


</SCRIPT>

</head>
<body>

	<!-- 分配许可的模态窗口 -->
	<div class="modal fade" id="assignRoleForUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">为<b>张三</b>分配角色</h4>
				</div>
				<div class="modal-body">
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="42%">
								<div class="list_tit" style="border: solid 1px #D5D5D5; background-color: #F4F4B5;">
									张三，未分配角色列表
								</div>
							</td>
							<td width="15%">
								&nbsp;
							</td>
							<td width="43%">
								<div class="list_tit" style="border: solid 1px #D5D5D5; background-color: #F4F4B5;">
									张三，已分配角色列表
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<select size="15" name="srcList" id="srcList"
									style="width: 100%" multiple="multiple">
									<option>
										总裁
									</option>
									<option>
										市场部普通职员
									</option>
									<option>
										市场总监
									</option>
									<option>
										销售部销售员
									</option>
									<option>
										销售总监
									</option>
								</select>
							</td>
							<td>
								<p align="center">
									<a href="javascript:void(0);" title="分配角色"><span class="glyphicon glyphicon-chevron-right" style="font-size: 20px;"></span></a>
								</p>
								<br><br>
								<p align="center">
									<a href="javascript:void(0);" title="撤销角色"><span class="glyphicon glyphicon-chevron-left" style="font-size: 20px;"></span></a>
								</p>
							</td>
							<td>
								<select name="destList" size="15" multiple="multiple"
									id="destList" style="width: 100%">
									<option>
										副总裁
									</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 编辑用户的模态窗口 -->
	<div class="modal fade" id="editUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-loginActNo" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-loginActNo" >
							</div>
							<label for="edit-username" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-username" >
							</div>
						</div>
						<div class="form-group">
							<label for="edit-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="edit-loginPwd" >
							</div>
							<label for="edit-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="edit-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-expireTime">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-lockStatus" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-lockStatus">
								  <option></option>
								  <option value="1" >启用</option>
								  <option value="0">锁定</option>
								</select>
							</div>
							<label for="edit-dept" class="col-sm-2 control-label">部门名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-dept">
									<option></option>
									<c:forEach items="${dept}" var="c">
										<option value="${c.deptno}">${c.deptname}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-allowIps" style="width: 280%" placeholder="多个用逗号隔开" >
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateUserBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户明细 <small>${user.name}</small></h3>
			</div>
			<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
				<button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
			</div>
		</div>
	</div>
	
	<div style="position: relative; left: 60px; top: -50px;">
		
		<div id="myTabContent" class="tab-content">
			<div class="tab-pane fade in active" id="role-info">
				<div style="position: relative; top: 20px; left: -30px;">
					<div style="position: relative; left: 40px; height: 30px; top: 20px;">
						<div style="width: 300px; color: gray;">登录帐号</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.loginAct}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 40px;">
						<div style="width: 300px; color: gray;">用户姓名</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.name}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 60px;">
						<div style="width: 300px; color: gray;">邮箱</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.email}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 80px;">
						<div style="width: 300px; color: gray;">失效时间</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.expireTime}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 100px;">
						<div style="width: 300px; color: gray;">允许访问IP</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.allowIps}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">锁定状态</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.lockState}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 140px;">
						<div style="width: 300px; color: gray;">部门名称</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${user.deptno}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
						<button style="position: relative; left: 76%; top: -40px;" type="button" class="btn btn-default" id="editUserBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
					</div>
				</div>
			</div>
			<div class="tab-pane fade" id="permission-info">
				<div style="position: relative; top: 20px; left: 0px;">
					<ul id="treeDemo" class="ztree" style="position: relative; top: 15px; left: 15px;"></ul>
					<div style="position: relative;top: 30px; left: 76%;">
						<button type="button" class="btn btn-default" data-toggle="modal" data-target="#assignRoleForUserModal"><span class="glyphicon glyphicon-edit"></span> 分配角色</button>
					</div>
				</div>--%>
			</div>
		</div>
	</div>	
	
</body>
</html>