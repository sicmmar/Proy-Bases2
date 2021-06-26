CREATE DATABASE NETFLIX;

USE [NETFLIX]
GO

EXEC sp_addlinkedserver
    @server = N'192.168.1.2',
    @srvproduct = N'SQL Server';
GO

SELECT name FROM [192.168.1.2].master.sys.databases;