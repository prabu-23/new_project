USE [NewColumbus3.0]
GO

/****** Object:  StoredProcedure [dbo].[New_booking_TourismFee]    Script Date: 15-02-2024 10:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec New_booking_TourismFee @partycode=N'000357',@rmtypcode=N'001926',@checkin=N'2024/01/02',@checkout=N'2024/01/08',@noofrooms=N'',@AgentCode=N'000007'

--sp_helptext New_booking_TourismFee
--select * from  currrates
--select * from agentmast
--select * from contracts_tourismfee
  
--sp_helptext  New_booking_TourismFee  
   
--  select * from contracts_tourismfee   

CREATE proc [dbo].[New_booking_TourismFee]          
(        
@partycode varchar(20),        
@rmtypcode varchar(20),        
@checkin varchar(10),        
@checkout varchar(10),    
@noofrooms int ,  
@AgentCode varchar(20)  
  
--@mealcode varchar(20),    
--@rateplanid varchar(1000),      
--@agentcode varchar(20),        
--@sourcecountry varchar(20),       
--@NoEB int,     
--@requestid varchar(20)='',    
--@rlineno int=0          
)      
    
as    
    
declare @noofnight int     
select @noofnight=DATEDIFF(d,@checkin,@checkout)    
  
 declare @agentcurrcode varchar(20)   
 select @agentcurrcode=currcode from agentmast(nolock) where agentcode=@AgentCode  
  
 Declare @CRate numeric(18,12);  
select @CRate = convrate from currrates (nolock) where  tocurr =@agentcurrcode and currcode = 'AED'  
    
-- select Tourismfee as unitTourismFee,cast((totalFee *@CRate) as decimal(18,2)) as tourismFee, @noofnight noOfNight,cast((totalfee *@noofrooms * @noofnight *@CRate) as decimal(18,2)) as totalTourismFee,@agentcurrcode AgentCurcode  

select Tourismfee as unitTourismFee,cast((totalFee *@CRate) as decimal(18,2)) as tourismFee, @noofnight noOfNight,
cast((totalfee *@noofrooms * @noofnight *@CRate) as decimal(18,2)) as totalTourismFee,@agentcurrcode AgentCurcode  ,
totalFee as costUnitPrice, (totalfee *@noofrooms * @noofnight) as costTotalPrice
  
  
from contracts_tourismfee where partycode = @partycode and rmtypcode =@rmtypcode    
and   ((@checkin between fromdate and todate) or (@checkout between fromdate and todate)        
or (@checkin < fromdate and @checkout > todate))  
  
GO


