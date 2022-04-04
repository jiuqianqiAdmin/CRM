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
	<script type="text/javascript">
		$(function () {
			//为删除用户按钮绑定事件
			$("#deleteUserBtn").click(function () {
				var $qx=$("input[name=xz]:checked")
				if($qx.length==0){
					alert("请选择要删除的用户")
				}else {
					if(confirm("确定删除所选用户吗？")){
						var param="";
						for (var i=0;i<$qx.length;i++){
							param+="id="+$($qx[i]).val();
							if(i<$qx.length-1){
								param+="&";
							}
						}
						$.ajax({
							url : "settings/user/deleteUserById.do",
							data:param,
							type : "post",
							dataType : "json",
							success : function (data) {
								if(data.success){
									pageList(1,$("#settingsPage").bs_pagination('getOption','rowsPerPage'));
								}else {
									alert("删除线索失败")
								}
							}
						})
					}

				}
			})
			//添加用户绑定事件
			$("#saveUserBtn").click(function () {
				if($.trim($("#create-loginPwd").val())==""&&$.trim($("#create-confirmPwd").val())==""){
					alert("密码不能为空")
				}else {
					var newPwd = $.trim($("#create-loginPwd").val())
					var confirmPwd = $.trim($("#create-confirmPwd").val())
					if (newPwd == confirmPwd) {
						$.ajax({
							url: "settings/user/saveUser.do",
							data: {
								"loginAct": $.trim($("#create-loginActNo").val()),
								"name": $.trim($("#create-username").val()),
								"loginPwd": $.trim($("#create-loginPwd").val()),
								"email": $.trim($("#create-email").val()),
								"expireTime": $.trim($("#create-expireTime").val()),
								"lockState": $.trim($("#create-lockStatus").val()),
								"deptno": $.trim($("#create-dept").val()),
								"allowIps": $.trim($("#create-allowIps").val())

							},
							type: "get",
							dataType: "json",
							success: function (data) {
								if (data.success) {
									$("#createUserModal").modal("hide");
									$("#createUserModalFrom")[0].reset();
									pageList(1, $("#settingsPage").bs_pagination('getOption', 'rowsPerPage'));
								} else {
									alert("创建失败，请重试")
								}

							}
						})
					} else {
						alert("密码不一致")
					}
				}
			})
				//全选
				$("#qx").click(function () {
					$("input[name=xz]").prop("checked", this.checked);
				})
				$("#settingsBody").on("click", $("input[name=xz]"), function () {
					$("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length)
				})
				pageList(1, 2)
				//查询按钮绑定事件
				$("#searchUserBtn").click(function () {
					$("#hidden-name").val($.trim($("#search-name").val()));
					$("#hidden-deptName").val($.trim($("#search-deptName").val()));
					$("#hidden-lockState").val($.trim($("#search-lockState").val()));
					$("#hidden-startTime").val($.trim($("#search-startTime").val()));
					$("#hidden-endTime").val($.trim($("#search-endTime").val()));
					pageList(1, 2)
				})
//时间日历
				$(".time").datetimepicker({
					minView: "month",
					language: 'zh-CN',
					format: 'yyyy-mm-dd',
					autoclose: true,
					todayBtn: true,
					pickerPosition: "bottom-left"
				});
			})

		//刷新用户列表
		function pageList(pageNo,pageSize) {
			//每次刷新取消全选框的选择
			$("#qx").prop("checked", false);
			//从隐藏域中取出点击分页组件前的值
			$("#search-name").val($.trim($("#hidden-name").val()));
			$("#search-deptName").val($.trim($("#hidden-deptName").val()));
			$("#search-lockState").val($.trim($("#hidden-lockState").val()));
			$("#search-startTime").val($.trim($("#hidden-startTime").val()));
			$("#search-endTime").val($.trim($("#hidden-endTime").val()));
			$.ajax({
				url: "settings/user/pageList.do",
				data: {
					"pageNo": pageNo,
					"pageSize": pageSize,
					"name": $.trim($("#search-name").val()),
					"deptName": $.trim($("#search-deptName").val()),
					"lockState": $.trim($("#search-lockState").val()),
					"startTime": $.trim($("#search-startTime").val()),
					"endTime": $.trim($("#search-endTime").val()),
				},
				type: "get",
				dataType: "json",
				success: function (data) {
					var html = "";
					$.each(data.dataList, function (i, n) {
						html += '<tr>';
						html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
						html += '<td>' + i + '</td>';
						html += '<td><a  href="settings/user/detail.do?id='+n.id+'">' + n.loginAct + '</a></td>';
						html += '<td>' + n.name + '</td>';
						html += '<td>' + n.deptno + '</td>';
						html += '<td>' + n.email + '</td>';
						html += '<td>' + n.expireTime + '</td>';
						html += '<td>' + n.allowIps + '</td>';
						html += '<td>' + n.lockState + '</td>';
						html += '<td>' + n.createBy + '</td>';
						html += '<td>' + n.createTime + '</td>';
						html += '<td>' + n.editBy + '</td>';
						html += '<td>' + n.editTime + '</td>';
						html += '</tr>  ';
					})
					$("#settingsBody").html(html);
					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
					//分页
					$("#settingsPage").bs_pagination({
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
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-deptName">
<input type="hidden" id="hidden-lockState">
<input type="hidden" id="hidden-startTime">
<input type="hidden" id="hidden-endTime">
	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createUserModalFrom">
					
						<div class="form-group">
							<label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginActNo">
							</div>
							<label for="create-username" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-username">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-expireTime">
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockStatus">
								  <option></option>
								  <option value="1">启用</option>
								  <option value="0">锁定</option>
								</select>
							</div>
							<label for="create-dept" class="col-sm-2 control-label">部门<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="create-dept">
                                    <option></option>
									<c:forEach items="${dept}" var="c">
										<option value="${c.deptno}">${c.deptname}</option>
									</c:forEach>
                                </select>
                            </div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveUserBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" type="text" id="search-name">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">部门名称</div>
		      <input class="form-control" type="text" id="search-deptName">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select class="form-control" id="search-lockState">
			  	  <option></option>
			      <option value="0">锁定</option>
				  <option value="1">启用</option>
			  </select>
		    </div>
		  </div>
		  <br><br>
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">失效时间</div>
			  <input class="form-control time" type="text" id="search-startTime" />
		    </div>
		  </div>
		  
		  ~
		  
		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control time" type="text" id="search-endTime" />
		    </div>
		  </div>
		  
		  <button type="button" class="btn btn-default" id="searchUserBtn">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createUserModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger" id="deleteUserBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx" /></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>
					<td>部门名称</td>
					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>
					<td>修改者</td>
					<td>修改时间</td>
				</tr>
			</thead>
			<tbody id="settingsBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td><a  href="detail.jsp">zhangsan</a></td>
					<td>张三</td>
					<td>市场部</td>
					<td>zhangsan@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>启用</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td><a  href="detail.jsp">lisi</a></td>
					<td>李四</td>
					<td>市场部</td>
					<td>lisi@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>锁定</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div id="settingsPage"></div>
	</div>
			
</body>
</html>