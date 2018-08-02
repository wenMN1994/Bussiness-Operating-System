<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<script type="text/javascript">
	function doAdd(){
		$('#addStaffWindow').window("open");
	}
	
	function doView(){
		$('#searchStaffWindow').window("open");
	}
	
	function doDelete(){
		//获得所有选中的行
		var rows = $("#grid").datagrid("getSelections");
		if(rows.length == 0){
			//没有选中的的记录，弹出提示
			$.messager.alert("提示信息","请选择需要删除的取派员！","info");
		}else {
			//弹出确认框
			$.messager.confirm("提示信息","你确认删除当前选中的取派员吗？",function(r){
				if(r){
					var ids = "";
					var array = new Array();
					//用户点击确认按钮，删除取派员
					//获取当前选中记录的id
					for(var i=0;i<rows.length;i++){
						var id = rows[i].id;//取派员id
						array.push(id);
					}
					ids = array.join(",");
					//发送请求，将ids提交到Action
					location.href = "${pageContext.request.contextPath }/staffAction_delete.action?ids="+ids;
				}
			});
		}
	}
	
	function doRestore(){
		//获得所选中的行
		var rows = $("#grid").datagrid("getSelections");
		if(rows.length == 0){
			//没有选中的的记录，弹出提示
			$.messager.alert("提示信息","请选择需要还原的取派员！","info");
		}else {
			//弹出确认框
			$.messager.confirm("提示信息","你确认还原当前选中的取派员吗？",function(r){
				if(r){
					var ids = "";
					var array = new Array();
					//用户点击确认按钮，还原取派员
					//获取当前选中记录的id
					for(var i=0;i<rows.length;i++){
						var id = rows[i].id;//取派员id
						array.push(id);
					}
					ids = array.join(",");
					location.href = "${pageContext.request.contextPath }/staffAction_restore.action?ids="+ids;
				}
			});
		}
	}
	//工具栏
	var toolbar = [ {
		id : 'button-view',	
		text : '查询',
		iconCls : 'icon-search',
		handler : doView
	}, {
		id : 'button-add',
		text : '增加',
		iconCls : 'icon-add',
		handler : doAdd
	}, {
		id : 'button-delete',
		text : '作废',
		iconCls : 'icon-cancel',
		handler : doDelete
	},{
		id : 'button-save',
		text : '还原',
		iconCls : 'icon-save',
		handler : doRestore
	}];
	// 定义列
	var columns = [ [ {
		field : 'id',
		checkbox : true,
	},{
		field : 'name',
		title : '姓名',
		width : 120,
		align : 'center'
	}, {
		field : 'telephone',
		title : '手机号',
		width : 120,
		align : 'center'
	}, {
		field : 'haspda',
		title : '是否有PDA',
		width : 120,
		align : 'center',
		formatter : function(data,row, index){
			if(data=="1"){
				return "有";
			}else{
				return "无";
			}
		}
	}, {
		field : 'deltag',
		title : '是否作废',
		width : 120,
		align : 'center',
		formatter : function(data,row, index){
			if(data=="0"){
				return "正常使用"
			}else{
				return "已作废";
			}
		}
	}, {
		field : 'standard',
		title : '取派标准',
		width : 120,
		align : 'center'
	}, {
		field : 'station',
		title : '所属单位',
		width : 200,
		align : 'center'
	} ] ];
	
	$(function(){
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({visibility:"visible"});
		
		// 取派员信息表格
		$('#grid').datagrid( {
			iconCls : 'icon-forward',
			fit : true,
			border : false,
			rownumbers : true,
			striped : true,
			pageSize:10,
			pageList: [10,30,50,100],
			pagination : true, //显示分页条
			toolbar : toolbar,
			url : "${pageContext.request.contextPath }/staffAction_pageQuery.action",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow
		});
		
		// 添加取派员窗口
		$('#addStaffWindow').window({
	        title: '添加取派员',
	        width: 400,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		
		// 修改取派员窗口
		$('#editStaffWindow').window({
	        title: '修改取派员',
	        width: 400,
	        modal: true,//遮罩效果
	        shadow: true,//阴影效果
	        closed: true,//关闭
	        height: 400,
	        resizable:false
	    });
		
		//搜索取派员窗口
		$('#searchStaffWindow').window({
			title: '搜索取派员',
	        width: 400,
	        modal: true,//遮罩效果
	        shadow: true,//阴影效果
	        closed: true,//关闭
	        height: 300,
	        resizable:false
		});
		
	});

	//数据表格绑定的双击行事件对应的函数
	function doDblClickRow(rowIndex, rowData){
		//打开修改取派员窗口
		$('#editStaffWindow').window("open");
		//使用form表单对象的load方法回显数据
		$("#editStaffForm").form("load",rowData);
	}
	
	$(function(){
		//为保存按钮绑定事件
		$("#save").click(function(){
			//表单校验，如果通过，提交表单
			var v = $("#addStaffForm").form("validate");
			if(v){
				//校验通过，提交表单
				$("#addStaffForm").submit();
			}
		});
		
		//为修改按钮绑定事件
		$("#edit").click(function(){
			//表单校验，如果通过，提交表单
			var v = $("#editStaffForm").form("validate");
			if(v){
				$("#editStaffForm").submit();
			}
		});
		
		//为搜索按钮绑定事件
		$("#search").click(function(){
			//表单校验，如果通过，提交表单
			var v = $("#searchStaffForm").form("validate");
			if(v){
				$("#searchStaffForm").submit();
			}
		});
		
		var reg = /^1[3|4|5|7|8][0-9]{9}$/;
		//扩展手机号码校验规则
		$.extend($.fn.validatebox.defaults.rules, {
			telephone: {
				validator: function(value,param){
					return reg.test(value);
				},
				message: '手机号码输入有误！'
			}
		});
	});
</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
	<div class="easyui-window" title="对收派员进行添加" id="addStaffWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="addStaffForm" action="${pageContext.request.contextPath }/staffAction_add.action" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">收派员信息</td>
					</tr>
					<!-- TODO 这里完善收派员添加 table -->
					<!-- <tr>
						<td>取派员编号</td>
						<td><input type="text" name="id" class="easyui-validatebox" required="true"/></td>
					</tr> -->
					<tr>
						<td>姓名</td>
						<td><input type="text" name="name" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>手机</td>
						<td><input type="text" data-options="validType:'telephone'" name="telephone" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>单位</td>
						<td><input type="text" name="station" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td colspan="2">
						<input type="checkbox" name="haspda" value="1" />
						是否有PDA</td>
					</tr>
					<tr>
						<td>取派标准</td>
						<td>
							<input type="text" name="standard" class="easyui-validatebox" required="true"/>  
						</td>
					</tr>
					</table>
			</form>
		</div>
	</div>
	
	<!-- 修改取派员窗口 -->
	<div class="easyui-window" title="对收派员进行修改" id="editStaffWindow" collapsible="false" 
		minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="edit" icon="icon-edit" href="#" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="editStaffForm" action="${pageContext.request.contextPath }/staffAction_edit.action" method="post">
				<input type="hidden" name="id">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">收派员信息</td>
					</tr>
					<tr>
						<td>姓名</td>
						<td><input type="text" name="name" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>手机</td>
						<td><input type="text" data-options="validType:'telephone'" 
							name="telephone" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>单位</td>
						<td><input type="text" name="station" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td colspan="2">
						<input type="checkbox" name="haspda" value="1" />
						是否有PDA</td>
					</tr>
					<tr>
						<td>取派标准</td>
						<td>
							<input type="text" name="standard" class="easyui-validatebox" required="true"/>  
						</td>
					</tr>
					</table>
			</form>
		</div>
	</div>
	
	<!-- 查找取派员窗口 -->
	<div class="easyui-window" title="对收派员进行搜索" id="searchStaffWindow" collapsible="false" 
		minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="search" icon="icon-search" href="#" class="easyui-linkbutton" plain="true" >搜索</a>
			</div>
		</div>
		
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="searchStaffForm" action="${pageContext.request.contextPath }/staffAction_search.action" method="post">
				<input type="hidden" name="id">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">收派员搜索条件</td>
					</tr>
					<tr>
						<td>姓名</td>
						<td><input type="text" name="name" class="easyui-validatebox"/></td>
					</tr>
					<tr>
						<td>手机</td>
						<td><input type="text" data-options="validType:'telephone'" 
							name="telephone" class="easyui-validatebox"/></td>
					</tr>
					<tr>
						<td>单位</td>
						<td><input type="text" name="station" class="easyui-validatebox"/></td>
					</tr>
					</table>
			</form>
		</div>
	</div>
</body>
</html>	