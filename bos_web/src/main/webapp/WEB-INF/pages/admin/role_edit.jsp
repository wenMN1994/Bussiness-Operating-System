<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!-- 导入jquery核心类库 -->
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/jquery-3.2.1.js"></script>
<!-- 导入easyui类库 -->
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/js/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/js/easyui/ext/portal.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/css/default.css">	
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/easyui/ext/jquery.portal.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/easyui/ext/jquery.cookie.js"></script>
<script
	src="${pageContext.request.contextPath }/js/easyui/locale/easyui-lang-zh_CN.js"
	type="text/javascript"></script>
<!-- 导入ztree类库 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/js/ztree/zTreeStyle.css"
	type="text/css" />
<script
	src="${pageContext.request.contextPath }/js/ztree/jquery.ztree.all-3.5.js"
	type="text/javascript"></script>	
<script type="text/javascript">
	$(function(){
		// 授权树初始化
		var setting = {
			data : {
				key : {
					title : "t"
				},
				simpleData : {
					enable : true
				}
			},
			check : {
				enable : true,
			}
		};
		
		$.ajax({
			url : '${pageContext.request.contextPath}/functionAction_listajax.action',
			type : 'POST',
			dataType : 'text',
			success : function(data) {
				var zNodes = eval("(" + data + ")");
				$.fn.zTree.init($("#functionTree"), setting, zNodes);
			},
			error : function(msg) {
				alert('树加载异常!');
			}
		});
		
		
		
		// 点击保存
		$('#edit_save').click(function(){
			var v = $("#roleEditForm").form("validate");
			if(v){
				//根据ztree的id获取ztree对象
				var treeObj = $.fn.zTree.getZTreeObj("functionTree");
				//获取ztree上选中的节点，返回数组对象
				var nodes = treeObj.getCheckedNodes(true);
				var array = new Array();
				for(var i=0;i<nodes.length;i++){
					var id = nodes[i].id;
					array.push(id);
				}
				var functionIds = array.join(",");
				//为隐藏域赋值（权限的id拼接成的字符串）
				$("input[name=functionIds]").val(functionIds);
				$("#roleEditForm").submit();
			}
		});
		
		//返回按钮
		$('#back').click(function(){
			location.href='${pageContext.request.contextPath}/page_admin_role.action';
		});
	});
</script>	
</head>
<body class="easyui-layout">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="back" icon="icon-back" href="#" class="easyui-linkbutton" plain="true" >返回</a>
				<a id="edit_save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="roleEditForm" action="${pageContext.request.contextPath}/roleAction_edit.action" method="post">
				<input type="hidden" name="functionIds" />
				<input type="hidden" name="id" value="${editRole.id }" />
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">角色信息</td>
					</tr>
					<tr>
						<td width="200">关键字</td>
						<td>
							<input type="text" name="code" class="easyui-validatebox" data-options="required:true" value="${editRole.code }" />						
						</td>
					</tr>
					<tr>
						<td>名称</td>
						<td><input type="text" name="name" class="easyui-validatebox" data-options="required:true" value="${editRole.name }" /></td>
					</tr>
					<tr>
						<td>描述</td>
						<td>
							<textarea name="description" rows="4" cols="60">${editRole.description }</textarea>
						</td>
					</tr>
					<tr>
						<td>授权</td>
						<td>
							<ul id="functionTree" class="ztree"></ul>
						</td>
					</tr>
					</table>
			</form>
		</div>
</body>
</html>