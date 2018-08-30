<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理定区/调度排班</title>
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
		$('#addDecidedzoneWindow').window("open");
		//重新加载未分区表格数据
		$("#subareaGrid").datagrid("resize");
	}
	
	function doEdit(){
		alert("修改...");
	}
	
	function doDelete(){
		alert("删除...");
	}
	
	function doSearch(){
		$('#searchDecidedzoneWindow').window("open");
	}
	
	function doAssociations(){
		//获取当前数据表格所有选中的行，返回数组
		var rows = $("#grid").datagrid("getSelections");
		if(rows.length != 1){
			//弹出提示
			$.messager.alert("提示信息","请选择一个定区操作！","warning");
		}else{
			//选中了一个定区
			$('#customerWindow').window('open');
			//清理下拉框
			$("#noassociationSelect").empty();
			$("#associationSelect").empty();
			//发送ajax请求，请求定区Action，在定区Action中通过crm代理对象完成对于crm服务远程调用获取客户数据
			var url_1 = "${pageContext.request.contextPath }/decidedzoneAction_findListNotAssociation.action";
			$.post(url_1,function(data){
				//遍历json数组
				for(var i = 0; i < data.length; i++){
					var id = data[i].id;
					var name = data[i].name;
					var telephone = data[i].telephone;
					name = name + "(" + telephone + ")";
					$("#noassociationSelect").append("<option value='"+id+"'>"+name+"</option>");
				}
			});
			
			//发送ajax请求，请求定区Action，在定区Action中通过crm代理对象完成对于crm服务远程调用获取客户数据
			var url_2 = "${pageContext.request.contextPath }/decidedzoneAction_findListHasAssociation.action";
			var decidedzoneId = rows[0].id;
			$.post(url_2,{"id":decidedzoneId},function(data){
				//遍历json数组
				for(var i=0;i<data.length;i++){
					var id = data[i].id;
					var name = data[i].name;
					var telephone = data[i].telephone;
					name = name + "(" + telephone + ")";
					$("#associationSelect").append("<option value='"+id+"'>"+name+"</option>");
				}
			});
		}
	}
	
	//工具栏
	var toolbar = [ {
		id : 'button-search',	
		text : '查询',
		iconCls : 'icon-search',
		handler : doSearch
	}, {
		id : 'button-add',
		text : '增加',
		iconCls : 'icon-add',
		handler : doAdd
	}, {
		id : 'button-edit',	
		text : '修改',
		iconCls : 'icon-edit',
		handler : doEdit
	},{
		id : 'button-delete',
		text : '删除',
		iconCls : 'icon-cancel',
		handler : doDelete
	},{
		id : 'button-association',
		text : '关联客户',
		iconCls : 'icon-sum',
		handler : doAssociations
	}];
	// 定义列
	var columns = [ [ {
		field : 'id',
		title : '定区编号',
		width : 120,
		align : 'center'
	},{
		field : 'name',
		title : '定区名称',
		width : 120,
		align : 'center'
	}, {
		field : 'staff.name',
		title : '负责人',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.staff.name;
		}
	}, {
		field : 'staff.telephone',
		title : '联系电话',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.staff.telephone;
		}
	}, {
		field : 'staff.station',
		title : '所属公司',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.staff.station;
		}
	} ] ];
	
	$(function(){
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({visibility:"visible"});
		
		// 收派标准数据表格
		$('#grid').datagrid( {
			iconCls : 'icon-forward',
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			pageSize:10,
			pageList: [10,30,50,100],
			pagination : true,
			toolbar : toolbar,
			url : "${pageContext.request.contextPath }/decidedzoneAction_pageQuery.action",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow
		});
		
		// 添加、修改定区
		$('#addDecidedzoneWindow').window({
	        title: '添加修改定区',
	        width: 650,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		
		// 查询定区
		$('#searchDecidedzoneWindow').window({
	        title: '查询定区',
	        width: 400,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		
		//定义一个工具方法，用于将指定的form表单中所有的输入项转为json数据{key:value,key:value}
		$.fn.serializeJson=function(){  
            var serializeObj={};  
            var array=this.serializeArray();
            $(array).each(function(){  
                if(serializeObj[this.name]){  
                    if($.isArray(serializeObj[this.name])){  
                        serializeObj[this.name].push(this.value);  
                    }else{  
                        serializeObj[this.name]=[serializeObj[this.name],this.value];  
                    }  
                }else{  
                    serializeObj[this.name]=this.value;   
                }  
            });  
            return serializeObj;  
        }; 
		
		//为搜索按钮绑定事件
		$("#search").click(function(){
			//将指定的form表单中所有的输入项转为json数据{key:value,key:value}
			var p = $("#searchDecidedzoneFrom").serializeJson();
			console.info(p);
			//调用数据表格的load方法，重新发送一次ajax请求，并且提交参数
			$("#grid").datagrid("load",p);
			//关闭查询窗口
			$("#searchDecidedzoneWindow").window("close");
		});
		
		//为清空按钮绑定事件
		$("#empty").click(function(){
			$('#searchDecidedzoneFrom')[0].reset();
		});
		
	});
	
	$(function(){
		//定去添加保存
		$("#add_save").click(function(){
			//表单校验，如果校验通过再提交表单
			var v = $("#addDecidedzoneForm").form("validate");
			if(v){
				$("#addDecidedzoneForm").submit();
			}
		});
		
		//为左右移动按钮绑定事件
		$("#toRight").click(function(){
			$("#associationSelect").append($("#noassociationSelect option:selected"));
		});
		$("#toLeft").click(function(){
			$("#noassociationSelect").append($("#associationSelect option:selected"));
		});
		
		//为关联客户按钮绑定事件
		$("#associationBtn").click(function(){
			var rows = $("#grid").datagrid("getSelections");
			var id = rows[0].id;
			//为隐藏域（存放定区id）赋值
			$("input[name=id]").val(id);
			//提交表单之前，需要将右侧下拉框中所有的选项选中,为option添加一个selected属性
			$("#associationSelect option").attr("selected","selected");
			$("#customerForm").submit();
		});
	});

	function doDblClickRow(rowIndex,rowData){
		$('#association_subarea').datagrid( {
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			url : "${pageContext.request.contextPath }/subareaAction_findListByDecidedzoneId.action?decidedzoneId="+rowData.id,
			columns : [ [{
				field : 'id',
				title : '分拣编号',
				width : 120,
				align : 'center'
			},{
				field : 'province',
				title : '省',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.region.province;
				}
			}, {
				field : 'city',
				title : '市',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.region.city;
				}
			}, {
				field : 'district',
				title : '区',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.region.district;
				}
			}, {
				field : 'addresskey',
				title : '关键字',
				width : 120,
				align : 'center'
			}, {
				field : 'startnum',
				title : '起始号',
				width : 100,
				align : 'center'
			}, {
				field : 'endnum',
				title : '终止号',
				width : 100,
				align : 'center'
			} , {
				field : 'single',
				title : '单双号',
				width : 100,
				align : 'center'
			} , {
				field : 'position',
				title : '位置',
				width : 200,
				align : 'center'
			} ] ]
		});
		$('#association_customer').datagrid( {
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			url : "${pageContext.request.contextPath }/decidedzoneAction_findListHasAssociation.action?id="+rowData.id,
			columns : [[{
				field : 'id',
				title : '客户编号',
				width : 120,
				align : 'center'
			},{
				field : 'name',
				title : '客户名称',
				width : 120,
				align : 'center'
			}, {
				field : 'station',
				title : '所属单位',
				width : 120,
				align : 'center'
			}]]
		});
		
	}
</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
	<div region="south" border="false" style="height:150px">
		<div id="tabs" fit="true" class="easyui-tabs">
			<div title="关联分区" id="subArea"
				style="width:100%;height:100%;overflow:hidden">
				<table id="association_subarea"></table>
			</div>	
			<div title="关联客户" id="customers"
				style="width:100%;height:100%;overflow:hidden">
				<table id="association_customer"></table>
			</div>	
		</div>
	</div>
	
	<!-- 添加分区Start -->
	<div class="easyui-window" title="定区添加" id="addDecidedzoneWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="add_save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="addDecidedzoneForm" action="${pageContext.request.contextPath }/decidedzoneAction_add.action" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">定区信息</td>
					</tr>
					<tr>
						<td>定区编码</td>
						<td><input type="text" name="id" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>定区名称</td>
						<td><input type="text" name="name" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>选择负责人</td>
						<td>
							<input class="easyui-combobox" name="staff.id"  
    							data-options="valueField:'id',textField:'name',url:'${pageContext.request.contextPath }/staffAction_listajax.action'" />  
						</td>
					</tr>
					<tr height="300">
						<td valign="top">关联分区</td>
						<td>
							<table id="subareaGrid"  class="easyui-datagrid" border="false" style="width:400px;height:300px" data-options="url:'${pageContext.request.contextPath}/subareaAction_listajax.action',fitColumns:true,singleSelect:false">
								<thead>  
       								<tr>  
           								<th data-options="field:'subareaid',width:30,checkbox:true">编号</th>  
           								<th data-options="field:'addresskey',width:150,align:'center'">关键字</th>  
           								<th data-options="field:'position',width:200,align:'center'">位置</th>  
       								</tr>  
   								</thead> 
							</table>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<!-- 添加分区 End -->
	
	<!-- 查询定区 Start -->
	<div class="easyui-window" title="查询定区窗口" id="searchDecidedzoneWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="searchDecidedzoneFrom">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">查询条件</td>
					</tr>
					<tr>
						<td>定区编码</td>
						<td><input type="text" name="id" class="easyui-validatebox"/></td>
					</tr>
					<tr>
						<td>所属单位</td>
						<td><input type="text" name="staff.station" class="easyui-validatebox"/></td>
					</tr>
					<tr>
						<td colspan="2">
							<a id="search" icon="icon-search" href="#" class="easyui-linkbutton">查询</a> 
							<a id="empty" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">清空</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<!-- 查询定区 End -->
	
	<!-- 关联客户窗口 Start -->
	<div class="easyui-window" title="关联客户窗口" id="customerWindow" collapsible="false" closed="true" minimizable="false" maximizable="false" resizable="false" style="top:20px;left:200px;width: 600px;height: 400px;">
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="customerForm" action="${pageContext.request.contextPath }/decidedzoneAction_assigncustomerstodecidedzone.action" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="3">关联客户</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" name="id" id="customerDecidedZoneId" />
							<select id="noassociationSelect" multiple="multiple" size="15"></select>
						</td>
						<td>
							<a class="easyui-linkbutton" id="toRight">添加 》</a><br/><br/>
							<a class="easyui-linkbutton" id="toLeft">《 移除</a>
						</td>
						<td>
							<select id="associationSelect" name="customerIds" multiple="multiple" size="15"></select>
						</td>
					</tr>
					<tr>
						<td colspan="3" align="center" ><a id="associationBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'">关联客户</a> </td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<!-- 关联客户窗口 End -->
</body>
</html>