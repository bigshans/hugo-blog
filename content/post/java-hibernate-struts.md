---
title: openjdk 11 配置 struts 2.5 + hibernate 5.3 环境
date: 2018-12-02 13:12:22
tags:
- Java
- Struts
- Hibernate
categories:
- Java
---

从昨天开始配置这个环境配到吐血，今天终于解决了，采用 idea 默认的配置无法使用，以前的项目可以用现在新建的不行了，我也不是很懂。 struts 一直报找不到 action ，我猜可能生成的目录变了，但改来改去着实难受，我也没耐心去猜，不如重新搞一个，所以本着折腾的精神搞出来了。

<!--more-->

首先声明，这个项目无法保证在 ide 下能正常用，但在命令行下是可以的。

## 1. mvn 创建项目

使用 maven 部署项目，用 archetype:generate 来自动生成项目。

```
mvn archetype:generate
```

选择 webapp ，我们部署一下我们的依赖。写一下 pom.xml 文件（请忽略 Fuck）。

``` xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>Fuckyou</groupId>
    <artifactId>FuckyouJAVA</artifactId>
    <packaging>war</packaging>
    <version>1.0-SNAPSHOT</version>
    <name>FuckyouJAVA Maven Webapp</name>
    <url>http://maven.apache.org</url>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>3.8.1</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.struts</groupId>
            <artifactId>struts2-core</artifactId>
            <version>2.5</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.11.1</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-api</artifactId>
            <version>2.11.1</version>
        </dependency>
        <dependency>
            <groupId>org.hibernate</groupId>
            <artifactId>hibernate-core</artifactId>
            <version>5.3.7.Final</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.31</version>
        </dependency>
        <dependency>
            <groupId>javax.xml.bind</groupId>
            <artifactId>jaxb-api</artifactId>
            <version>2.2.11</version>
        </dependency>
        <dependency>
            <groupId>com.sun.xml.bind</groupId>
            <artifactId>jaxb-core</artifactId>
            <version>2.2.11</version>
        </dependency>
        <dependency>
            <groupId>com.sun.xml.bind</groupId>
            <artifactId>jaxb-impl</artifactId>
            <version>2.2.11</version>
        </dependency>
        <dependency>
            <groupId>javax.activation</groupId>
            <artifactId>activation</artifactId>
            <version>1.1.1</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.eclipse.jetty</groupId>
                <artifactId>jetty-maven-plugin</artifactId>
                <version>9.4.12.v20180830</version>
                <configuration>
                    <webApp>
                        <contextPath>/</contextPath>
                    </webApp>
                    <stopKey>CTRL+C</stopKey>
                    <stopPort>8999</stopPort>
                    <scanIntervalSeconds>10</scanIntervalSeconds>
                    <scanTargets>
                        <scanTarget>src/main/webapp/WEB-INF/web.xml</scanTarget>
                    </scanTargets>
                </configuration>
            </plugin>
        </plugins>
        <finalName>FuckyouJAVA</finalName>

    </build>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
    </properties>
</project>
```

开发时我们使用 jetty ，发布时我们再把项目部署到 tomcat 上。由于 tomcat-maven-plugin 的版本过低不能用，所以我们得用 jetty ，不过请使用最新版本的的 jetty 插件，最新版本才能正常运行。

除此之外，log4j 是必要的，剩下的几个依赖是针对 javax 的依赖。

然后我们还要配置下 log4j 。在 src/main/resources 下，创建 log4j2.xml 文件，并配置。

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration>
    <Appenders>
        <Console name="STDOUT" target="SYSTEM_OUT">
            <PatternLayout pattern="%d %-5p [%t] %C{2} (%F:%L) - %m%n"/>
        </Console>
    </Appenders>
    <Loggers>
        <Logger name="com.opensymphony.xwork2" level="debug"/>
        <Logger name="org.apache.struts2" level="debug"/>
        <Root level="warn">
            <AppenderRef ref="STDOUT"/>
        </Root>
    </Loggers>
</Configuration>
```

这里 resources 文件夹放置所有的配置文件。 hibernate 和 struts 的配置文件也要放到这里， hibernate 的映射文件也要放在这里。 

## 2. struts 配置

struts 的配置和以前有较大区别。

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts PUBLIC
    "-//Apache Software Foundation//DTD Struts Configuration 2.5//EN"
    "http://struts.apache.org/dtds/struts-2.5.dtd">

<struts>

    <constant name="struts.enable.DynamicMethodInvocation" value="true"/>
    <constant name="struts.devMode" value="true"></constant>

    <package name="basicstruts2" extends="struts-default">
        <global-allowed-methods>regex:.*</global-allowed-methods>
        <action name="index">
            <result>/index.jsp</result>
        </action>
    </package>

</struts>
```

global-allowed-methods 标签是为了允许使用 action + ! + 方法 这种格式， struts.devMode 要为 true 。

然后配置拦截器。在 web.xml 里。

``` xml
 
<?xml version="1.0" encoding="UTF-8"?>
<web-app id="WebApp_ID" version="2.4"
        xmlns="http://java.sun.com/xml/ns/j2ee"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">
    <display-name>Basic Struts2</display-name>
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

    <filter>
        <filter-name>struts2</filter-name>
        <filter-class>org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter</filter-class>
    </filter>

    <filter-mapping>
        <filter-name>struts2</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

</web-app>
```

## 3. hibernate 的一些要点以及 HibernateSessionFactory 类

比 2.4 的版本少了 ng 包。现在可以开始运行了。使用 mvn jetty:run 命令运行即可。这样 struts 2.5 是配置好了。

然后 hibernate 5 可以开始配置了，比起 struts ，hibernate 反而好解决一点。只需注意一点，就是 hibernate 的配置文件是放在 resources 文件下的，所有映射文件的 resources 属性所对应的 root 目录是 resources 目录，class 目录是 java 目录的。

HibernateSessionFactory 这个的写法用以前的也可以。

``` java
import org.hibernate.HibernateException;
import org.hibernate.Metamodel;
import org.hibernate.query.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import javax.persistence.metamodel.EntityType;

import java.util.Map;

public class HibernateSessionFactory {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

}

```

其实整个项目部署下来并不是那么坑，但是由于 jdk 版本过高导致很多依赖不支持，一些依赖万年没有更新，所以不得不舍弃选择替代品。

以上。
