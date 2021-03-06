<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="contentRetreivalBlock.css"/>
<template:addResources type="css" resources="owl.carousel.css"/>
<template:addResources type="css" resources="owl.theme.default.css"/>
<template:addResources type="javascript" resources="owl.carousel.js"/>

<c:set var="siteNode" value="${renderContext.site}"/>
<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<jcr:nodeProperty node="${currentNode}" name="bannerText" var="bannerText"/>
<jcr:nodeProperty node="${currentNode}" name="maxItems" var="maxItems"/>
<jcr:nodeProperty node="${currentNode}" name="filter" var="topFilter"/>
<jcr:nodeProperty node="${currentNode}" name='j:startNode' var="startNode"/>
<jcr:nodeProperty node="${currentNode}" name='j:criteria' var="criteria"/>
<jcr:nodeProperty node="${currentNode}" name='j:sortDirection' var="sortDirection"/>
<jcr:nodeProperty node="${currentNode}" name='j:type' var="type"/>
<jcr:nodeProperty node="${currentNode}" name="j:catFilters" var="catFilters"/>
<jcr:nodeProperty node="${currentNode}" name="j:catNoFilters" var="catNoFilters"/>
<jcr:nodeProperty node="${currentNode}" name="j:selectedCat" var="selectedCat"/>
<jcr:nodeProperty node="${currentNode}" name="j:subNodesView" var="subNodesView"/>
<c:set var="rand">
    <%= java.lang.Math.round(java.lang.Math.random() * 10000) %>
</c:set>
<c:set var="carouselId" value="carousel-${rand}"/>
<c:if test="${not empty startNode}">
    <c:set var="startNode" value="${startNode.node}"/>
</c:if>
<c:if test="${empty startNode}">
    <c:set var="startNode" value="${jcr:getMeAndParentsOfType(renderContext.mainResource.node, 'jnt:page')[0]}"/>
</c:if>
<%-- get the child items --%>
<jcr:jqom var="listQuery"
          limit="${currentResource.moduleParams.queryLoadAllUnsorted == 'true' ? -1 : maxItems.long}">
    <query:selector nodeTypeName="${type.string}"/>
    <query:descendantNode path="${startNode.path}"/>
    <query:or>
        <c:forEach var="filter" items="${catFilters}">
            <c:if test="${not empty filter.string}">
                <query:equalTo propertyName="j:defaultCategory" value="${filter.string}"/>
            </c:if>
        </c:forEach>
    </query:or>
    <query:and>
        <query:or>
            <c:forEach var="noFilter" items="${catNoFilters}">
                <c:if test="${not empty noFilter.string}">
                    <query:notEqualTo propertyName="j:defaultCategory" value="${noFilter.string}"/>
                </c:if>
            </c:forEach>
        </query:or>
    </query:and>
    <c:if test="${not currentResource.moduleParams.queryLoadAllUnsorted == 'true'}">
        <query:sortBy propertyName="${criteria.string}" order="${sortDirection.string}"/>
    </c:if>
</jcr:jqom>
<c:if test="${not empty selectedCat}">
    <c:set value="${selectedCat[0].node.name}" var="selectedCat"/>
</c:if>
<c:if test="${empty selectedCat}">
    <c:set value="*" var="selectedCat"/>
</c:if>
<!-- Portfolio Grid Section -->
<div class="container">
    <div class="row">
        <div class="col-lg-12 text-center">
            <h2 class="section-heading">${title}</h2>
            <h5 class="section-subheading text-muted">${bannerText}</h5>
        </div>
    </div>
    <div class="row">
        <div class="blockList owl-carousel owl-theme animated" id="${carouselId}">
            <c:forEach items="${listQuery.nodes}" var="objects" varStatus="status">
                <div class="item">
                    <template:module node="${objects}" view="${subNodesView.string}"/>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    $('#${carouselId}').owlCarousel({
        loop: true,
        margin: 10,
        dots: true,
        nav: true,
        autoplay: true,

        navText: ['<span class="ion-ios-arrow-back">', '<span class="ion-ios-arrow-forward">'],
        animateOut: 'slideOutDown',
        animateIn: 'flipInX',
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 2
            },
            1000: {
                items: 3
            }
        }
    });
</script>