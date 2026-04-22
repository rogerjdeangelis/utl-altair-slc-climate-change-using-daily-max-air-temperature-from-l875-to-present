%let pgm=utl-altair-slc-climate-change-using-daily-max-air-temperature-from-l875-to-present;

%stop_submission;

Altair slc climate change using daily max air temperature from 1875 to present

Too long to post on a list, see github
https://github.com/rogerjdeangelis/utl-altair-slc-climate-change-using-daily-max-air-temperature-from-l875-to-present

Graphics
https://github.com/rogerjdeangelis/utl-altair-slc-climate-change-using-daily-max-air-temperature-from-l875-to-present/blob/main/balance_png.png
https://github.com/rogerjdeangelis/utl-altair-slc-climate-change-using-daily-max-air-temperature-from-l875-to-present/blob/main/temperaturebalance.png

Climate data source
https://www.ncei.noaa.gov/cdo-web/

Daily Temperature data
https://raw.githubusercontent.com/rogerjdeangelis/utl-altair-slc-climate-change-using-daily-max-air-temperature-from-l875-to-present/refs/heads/main/centralpark.csv

CONTENTS

  1 download NOAA csv
  2 convert csv to dataset
  3 95% ci mean max temp
  4 overlay 30 year histograms

PROBLEM: CREATE GRAPHS ABOVE AND THIS ONE

/**************************************************************************************************************************/
/*                                                                                                                        */
/*            95% Confidence Intervals of the Mean Max Air Temperature                                                    */
/*                                by 30 Year Periods                                                                      */
/*                                Central Park NYC NY                                                                     */
/*                                                                                                                        */
/*                                 1875 through 2024                                                                      */
/*                                                                                                                        */
/*        1875_1904     1905_1934     1935_1964     1965_1994   1995_2024                                                 */
/*          - +-------------+-------------+-------------+-------------+--                                                 */
/*        1 |                                                           |                                                 */
/*     64.0 +   30 YR SPAN   MEAN    95% Confidence Intervals of Mean   + 64.0                                            */
/*          |                              by 30 year Periods           |                                                 */
/*          |    1875_1904   59.315       Central Park NYC NY           |                                                 */
/*          |    1905_1934   60.982       1875 through 2024             |                                                 */
/*          |    1935_1964   62.279                              63.4 - |                                                 */
/*  30      |    1965_1994   62.619                                   | |      30                                         */
/*  YR 63.0 +    1995_2024   63.063                     - 63.0   63.1 * + 63.0 YR                                         */
/*          |                                           |             | |                                                 */
/*   M      |                             - 62.6        * 62.6   62.7 - |       M                                         */
/*   A      |                             |             |               |       A                                         */
/*   X      |                             * 62.3        - 62.3          |       X                                         */
/*          |                             |                             |                                                 */
/*   T 62.0 +                             - 61.9                        + 62.0  T                                         */
/*   E      |                                                           |       E                                         */
/*   M      |                                                           |       M                                         */
/*   P      |                                                           |       P                                         */
/*   E      |               - 61.3                                      |       E                                         */
/*   R      |               |                                           |       R                                         */
/*   A 61.0 +               * 61.0                                      + 61.0  A                                         */
/*   T      |               |                                           |       T                                         */
/*   U      |               - 60.6                                      |       U                                         */
/*   R      |                                                           |       R                                         */
/*   E      |                                                           |       E                                         */
/*          |                                                           |                                                 */
/*     60.0 +                                                           + 60.0                                            */
/*          |                           Note 1995-2024 does nto overlap |                                                 */
/*          | - 59.7                    1874-1904 or 1905-1934          |                                                 */
/*          | |                                                         |                                                 */
/*          | * 59.3                                                    |                                                 */
/*          | |                                                         |                                                 */
/*     59.0 + - 59.0                                                    + 59.0                                            */
/*          |                                                           |                                                 */
/*          - +-------------+-------------+-------------+-------------+--                                                 */
/*       1875 _1904     1905_1934     1935_1964     1965_1994   1995_2024                                                 */
/*                                                                                                                        */
/*                                1875 through 2024                                                                       */
/*                                                                                                                        */
/*          Small changes are very significant due to the large sample size                                               */
/**************************************************************************************************************************/


/*       _                     _                 _
/ |   __| | _____      ___ __ | | ___   __ _  __| |  _ __   ___   __ _  __ _   ___ _____   __
| |  / _` |/ _ \ \ /\ / / `_ \| |/ _ \ / _` |/ _` | | `_ \ / _ \ / _` |/ _` | / __/ __\ \ / /
| | | (_| | (_) \ V  V /| | | | | (_) | (_| | (_| | | | | | (_) | (_| | (_| || (__\__ \\ V /
|_|  \__,_|\___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_| |_| |_|\___/ \__,_|\__,_| \___|___/ \_/
*/

/*--- you can manually download or use proc http to get the csv from https://www.ncei.noaa.gov/cdo-web/ ---*/
/*--- you can also download the csv from tis repo                                                       ---*/

libname workx sas7bdat "d:/wpswrkx"; /*--- place in autoexec ---*/

proc datasets lib=workx kill;
run;

%utlfkil(d:/csv/centralpark.csv);

filename target "d:\csv\centralpark.csv" recfm=n lrecl=256;

proc http
  url="https://raw.githubusercontent.com/rogerjdeangelis/utl-altair-slc-consecutive-days-over-specific-temperature-in-r-using-rle/refs/heads/main/centralpark.csv"
  method="GET"
  out=target;
run;

/**************************************************************************************************************************/
/* d:\csv\centralpark.csv                                    max                                                          */
/*                                                           temp                                                         */
/* "STATION","NAME","DATE","TAVG","TMAX","TMIN","TOBS"        V                                                           */
/* "USW00094728","NY CITY CENTRAL PARK, NY US","1869-01-31",,"41","30",                                                   */
/* "USW00094728","NY CITY CENTRAL PARK, NY US","1869-02-01",,"33","25",                                                   */
/* "USW00094728","NY CITY CENTRAL PARK, NY US","1869-02-02",,"34","22",                                                   */
/* ...                                                                                                                    */
/* "USW00094728","NY CITY CENTRAL PARK, NY US","2026-04-13",,"79","49",                                                   */
/* "USW00094728","NY CITY CENTRAL PARK, NY US","2026-04-14",,"87","64",                                                   */
/* "USW00094728","NY CITY CENTRAL PARK, NY US","2026-04-15",,"90","67",                                                   */
/**************************************************************************************************************************/

/*   _                     _                 _   _
  __| | _____      ___ __ | | ___   __ _  __| | | | ___   __ _
 / _` |/ _ \ \ /\ / / `_ \| |/ _ \ / _` |/ _` | | |/ _ \ / _` |
| (_| | (_) \ V  V /| | | | | (_) | (_| | (_| | | | (_) | (_| |
 \__,_|\___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_| |_|\___/ \__, |
                                                         |___/
*/
1                                          Altair SLC         14:12 Tuesday, April 21, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1         libname workx sas7bdat "d:/wpswrkx"; /*--- place in autoexec ---*/
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx


Altair SLC

The DATASETS Procedure

         Directory

Libref           WORKX
Engine           SAS7BDAT
Physical Name    d:\wpswrkx
2
3         proc datasets lib=workx kill;
NOTE: No matching members in directory
4         run;
5
6         %utlfkil(d:/csv/centralpark.csv);
7
8         filename target "d:\csv\centralpark.csv" recfm=n lrecl=256;
NOTE: Procedure datasets step took :
      real time : 0.031
      cpu time  : 0.000


9
10        proc http
11          url="https://raw.githubusercontent.com/rogerjdeangelis/utl-altair-slc-consecutive-days-over-specific-temperature-in-r-using-rle/refs/heads/main/centralpark.csv"
12          method="GET"
13          out=target;
14        run;
NOTE: Call to [https://raw.githubusercontent.com/rogerjdeangelis/utl-altair-slc-consecutive-days-over-specific-temperature-in-r-using-rle/refs/heads/main/centralpark.csv] returned [200:OK]
NOTE: Procedure http step took :
      real time : 1.384
      cpu time  : 2.531


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 1.495
      cpu time  : 2.578

/*___                                  _     _             _       _                 _
|___ \    ___ ___  _ ____   _____ _ __| |_  | |_ ___    __| | __ _| |_ __ _ ___  ___| |_
  __) |  / __/ _ \| `_ \ \ / / _ \ `__| __| | __/ _ \  / _` |/ _` | __/ _` / __|/ _ \ __|
 / __/  | (_| (_) | | | \ V /  __/ |  | |_  | || (_) || (_| | (_| | || (_| \__ \  __/ |_
|_____|  \___\___/|_| |_|\_/ \___|_|   \__|  \__\___/  \__,_|\__,_|\__\__,_|___/\___|\__|
*/

/*--- CONVERT TO SLC SAS DATASET ----*/

data workx.centralpark;

 infile 'd:\csv\centralpark.csv' delimiter = ',' missover dsd lrecl=384 firstobs=2 ;

   informat station name date tavg tmaxx tmin $255. ;
   format datesas e8601da.;

 input
   station name date tavg tmaxx tmin;

 if not missing(cats(tmaxx,temp));

 datesas=input(date,e8601da.);

 tmax=input(tmaxx,best32.);
 year=year(datesas);

 if datesas > '31dec1869'd;

 keep datesas tmax year ;

run;

/*--- NO MISSING TEMPS, DATES AND DATA FOR EVERY DAY

proc sort data=workx.centralpark(where=(not missing(temp))) nodupkey out=dum(index=(datesas/unique));
where not missing(datesas);
by datesas;
run;quit;

data dif;
  set dum;
  dif=dif(datesas);
  if _n_=1 then do;
     len=input('2026-04-16',e8601da.) -input('1870-01-01',e8601da.);
     put len=;
  end;
  if dif ne 1 and _n_>1 then output;
run;

WORK.DIF has 0 observations no gaps

LEN=57083  (same as number of obs - we have no date gaps)

---*/

proc contents data=workx.centralpark position;
run;quit;

proc print data=workx.centralpark(obs=3);
format datesas e8601da.;
run;

proc print data=workx.centralpark(firstobs=57081);
format datesas e8601da.;
run;

/**************************************************************************************************************************/
/*    WORKX.centralpark total obs=57,418                                                                                  */
/*                                                                                                                        */
/*              DATESAS      TEMP                                                                                         */
/*    1        1870-01-01     43                                                                                          */
/*    2        1870-01-02     54                                                                                          */
/*    3        1870-01-03     41                                                                                          */
/*                                                                                                                        */
/*    57081    2026-04-13     79                                                                                          */
/*    57082    2026-04-14     87                                                                                          */
/*    57083    2026-04-15     90                                                                                          */
/**************************************************************************************************************************/

/*                             _     _
  ___ ___  _ ____   _____ _ __| |_  | | ___   __ _
 / __/ _ \| `_ \ \ / / _ \ `__| __| | |/ _ \ / _` |
| (_| (_) | | | \ V /  __/ |  | |_  | | (_) | (_| |
 \___\___/|_| |_|\_/ \___|_|   \__| |_|\___/ \__, |
                                             |___/
*/


1                                          Altair SLC       12:31 Wednesday, April 22, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1         data workx.centralpark;
2
3          infile 'd:\csv\centralpark.csv' delimiter = ',' missover dsd lrecl=384 firstobs=2 ;
4
5            informat station name date tavg tmaxx tmin $255. ;
6            format datesas e8601da.;
7
8          input
9            station name date tavg tmaxx tmin;
10
11         if not missing(cats(tmaxx,temp));
12
13         datesas=input(date,e8601da.);
14
15         tmax=input(tmaxx,best32.);
16         year=year(datesas);
17
18         if datesas > '31dec1869'd;
19
20         keep datesas tmax year ;
21
22        run;
NOTE: Variable "TEMP" may not be initialized

NOTE: The infile 'd:\csv\centralpark.csv' is:
      Filename='d:\csv\centralpark.csv',
      Owner Name=SLC\suzie,
      File size (bytes)=3971879,
      Create Time=10:36:31 Apr 19 2026,
      Last Accessed=12:30:10 Apr 22 2026,
      Last Modified=12:30:10 Apr 22 2026,
      Lrecl=384, Recfm=V

NOTE: 57418 records were read from file 'd:\csv\centralpark.csv'
      The minimum record length was 60
      The maximum record length was 73
NOTE: Data set "WORKX.centralpark" has 57083 observation(s) and 3 variable(s)
NOTE: The data step took :
      real time : 0.191
      cpu time  : 0.140


23
24        /*--- NO MISSING TEMPS, DATES AND DATA FOR EVERY DAY
25
26        proc sort data=workx.centralpark(where=(not missing(temp))) nodupkey out=dum(index=(datesas/unique));
27        where not missing(datesas);
28        by datesas;
29        run;quit;
30
31        data dif;
32          set dum;
33          dif=dif(datesas);
34          if _n_=1 then do;
35             len=input('2026-04-16',e8601da.) -input('1870-01-01',e8601da.);
36             put len=;
37          end;
38          if dif ne 1 and _n_>1 then output;
39        run;
40
41        WORK.DIF has 0 observations no gaps
42
43        LEN=57083  (same as number of obs - we have no date gaps)
44
45        ---*/
46
47        proc contents data=workx.centralpark position;
48        run;quit;
NOTE: Procedure contents step took :
      real time : 0.031
      cpu time  : 0.000


49
50        proc print data=workx.centralpark(obs=3);
51        format datesas e8601da.;
52        run;
NOTE: 3 observations were read from "WORKX.centralpark"
NOTE: Procedure print step took :
      real time : 0.000
      cpu time  : 0.000


53
54        proc print data=workx.centralpark(firstobs=57081);
55        format datesas e8601da.;
56        run;
NOTE: 3 observations were read from "WORKX.centralpark"
NOTE: Procedure print step took :
      real time : 0.015
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.350
      cpu time  : 0.218

/*____    ___  ____ _  __       _                         _
|___ /   / _ \| ___(_)/ /   ___(_)  _ __ ___   __ ___  __| |_ ___ _ __ ___  _ __
  |_ \  | (_) |___ \ / /   / __| | | `_ ` _ \ / _` \ \/ /| __/ _ \ `_ ` _ \| `_ \
 ___) |  \__, |___) / /_  | (__| | | | | | | | (_| |>  < | ||  __/ | | | | | |_) |
|____/     /_/|____/_/(_)  \___|_| |_| |_| |_|\__,_/_/\_\ \__\___|_| |_| |_| .__/
                                                                           |_|
*/

ods listing;

/*--- CANNOT USE 2025 BECAUSE OF 30 YEAR BOUNDARIES ---*/
data workx.span30;
  retain span30 1;
  set workx.centralpark(where=(1874< year(datesas) < 2025));
  if mod(_n_,10957)=0 then span30=span30+1;
  if span30<6;
  period=put(span30,span_to_yrs.);
run;

proc summary stackods data=workx.span30
   CSS
   CV  KURTOSIS  LCLM2  MAX
   MEAN  MEDIAN  MIN    N  NMISS    P1  P10  P20  P25  P30  P40  P5  P50
   P60  P70  P75  P80  P90  P95  P99  PROBT  Q1  Q3  QRANGE  RANGE  SKEWNESS  STDDEV
   STDERR  SUM     T  UCLM2  USS  VAR;
by span30;
var tmax;
output out=workx.statsmean
   CSS=
   CV=  KURTOSIS=  LCLM2=  MAX=
   MEAN= MEDIAN= MIN= N= NMISS= P1= P10= P20= P25= P30= P40= P5= P50=
   P60= P70= P75= P80= P90= P95= P99= PROBT= Q1= Q3= QRANGE= RANGE= SKEWNESS= STDDEV=
   STDERR= SUM= T= UCLM2= USS= VAR= / autoname;
run;

proc print data=workx.statsmean(keep=span30 tmax_n tmax_lclm2 tmax_mean tmax_uclm2);
format span30 span2yrs.;
run;quit;

proc transpose data=workx.STATSMEAN(keep=span30 tmax_n tmax_lclm2 tmax_mean tmax_uclm2) out=workx.xpo;
by span30;
var tmax_lclm2 tmax_mean Tmax_uclm2 ;
run;quit;

proc format ;
  value span2yrs
    1 = "1875_1904"
    2 = "1905_1934"
    3 = "1935_1964"
    4 = "1965_1994"
    5 = "1995_2024"
;run;

data workx.xpofix;
  set xpo;
  ano=put(col1,4.1);
run;

options ls=100 ps=80;
proc plot data= workx.xpofix;
  format span30 span2yrs.;
  plot col1 * span30='-' $ ano / box ;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*            95% Confidence Intervals of the Mean Max Air Temperature                                                    */
/*                                by 30 Year Periods                                                                      */
/*                                Central Park NYC NY                                                                     */
/*                                                                                                                        */
/*                                 1875 through 2024                                                                      */
/*                                                                                                                        */
/*        1875_1904     1905_1934     1935_1964     1965_1994   1995_2024                                                 */
/*          - +-------------+-------------+-------------+-------------+--                                                 */
/*        1 |                                                           |                                                 */
/*     64.0 +   30 YR SPAN   MEAN    95% Confidence Intervals of Mean   + 64.0                                            */
/*          |                              by 30 year Periods           |                                                 */
/*          |    1875_1904   59.315       Central Park NYC NY           |                                                 */
/*          |    1905_1934   60.982       1875 through 2024             |                                                 */
/*          |    1935_1964   62.279                              63.4 - |                                                 */
/*  30      |    1965_1994   62.619                                   | |      30                                         */
/*  YR 63.0 +    1995_2024   63.063                     - 63.0   63.1 * + 63.0 YR                                         */
/*          |                                           |             | |                                                 */
/*   M      |                             - 62.6        * 62.6   62.7 - |       M                                         */
/*   A      |                             |             |               |       A                                         */
/*   X      |                             * 62.3        - 62.3          |       X                                         */
/*          |                             |                             |                                                 */
/*   T 62.0 +                             - 61.9                        + 62.0  T                                         */
/*   E      |                                                           |       E                                         */
/*   M      |                                                           |       M                                         */
/*   P      |                                                           |       P                                         */
/*   E      |               - 61.3                                      |       E                                         */
/*   R      |               |                                           |       R                                         */
/*   A 61.0 +               * 61.0                                      + 61.0  A                                         */
/*   T      |               |                                           |       T                                         */
/*   U      |               - 60.6                                      |       U                                         */
/*   R      |                                                           |       R                                         */
/*   E      |                                                           |       E                                         */
/*          |                                                           |                                                 */
/*     60.0 +                                                           + 60.0                                            */
/*          |                           Note 1995-2024 does nto overlap |                                                 */
/*          | - 59.7                    1874-1904 or 1905-1934          |                                                 */
/*          | |                                                         |                                                 */
/*          | * 59.3                                                    |                                                 */
/*          | |                                                         |                                                 */
/*     59.0 + - 59.0                                                    + 59.0                                            */
/*          |                                                           |                                                 */
/*          - +-------------+-------------+-------------+-------------+--                                                 */
/*       1875 _1904     1905_1934     1935_1964     1965_1994   1995_2024                                                 */
/*                                                                                                                        */
/*                                1875 through 2024                                                                       */
/*                                                                                                                        */
/*          Small changes are very significant due to the large sample size                                               */
/**************************************************************************************************************************/
/*___  ____ _  __       _ _   _
 / _ \| ___(_)/ /   ___| (_) | | ___   __ _
| (_) |___ \ / /   / __| | | | |/ _ \ / _` |
 \__, |___) / /_  | (__| | | | | (_) | (_| |
   /_/|____/_/(_)  \___|_|_| |_|\___/ \__, |
                                      |___/
*/

1                                          Altair SLC       13:16 Wednesday, April 22, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1         ods listing;
2
3         /*--- CANNOT USE 2025 BECAUSE OF 30 YEAR BOUNDARIES ---*/
4         data workx.span30;
5           retain span30 1;
6           set workx.centralpark(where=(1874< year(datesas) < 2025));
7           if mod(_n_,10957)=0 then span30=span30+1;
8           if span30<6;
NOTE: Format span_to_yrs was not found or could not be loaded
9           period=put(span30,span_to_yrs.);
10        run;

NOTE: 54787 observations were read from "WORKX.centralpark"
NOTE: Data set "WORKX.span30" has 54784 observation(s) and 5 variable(s)
NOTE: The data step took :
      real time : 0.063
      cpu time  : 0.078


11
12        proc summary stackods data=workx.span30
13           CSS
14           CV  KURTOSIS  LCLM2  MAX
15           MEAN  MEDIAN  MIN    N  NMISS    P1  P10  P20  P25  P30  P40  P5  P50
16           P60  P70  P75  P80  P90  P95  P99  PROBT  Q1  Q3  QRANGE  RANGE  SKEWNESS  STDDEV
17           STDERR  SUM     T  UCLM2  USS  VAR;
18        by span30;
19        var tmax;
20        output out=workx.statsmean
21           CSS=
22           CV=  KURTOSIS=  LCLM2=  MAX=
23           MEAN= MEDIAN= MIN= N= NMISS= P1= P10= P20= P25= P30= P40= P5= P50=
24           P60= P70= P75= P80= P90= P95= P99= PROBT= Q1= Q3= QRANGE= RANGE= SKEWNESS= STDDEV=
25           STDERR= SUM= T= UCLM2= USS= VAR= / autoname;
26        run;
NOTE: 54784 observations were read from "WORKX.span30"
NOTE: Data set "WORKX.statsmean" has 5 observation(s) and 41 variable(s)
NOTE: Procedure summary step took :
      real time : 0.031
      cpu time  : 0.031


27
28        proc print data=workx.statsmean(keep=span30 tmax_n tmax_lclm2 tmax_mean tmax_uclm2);
NOTE: Format span2yrs was not found or could not be loaded
29        format span30 span2yrs.;
30        run;quit;
NOTE: 5 observations were read from "WORKX.statsmean"
NOTE: Procedure print step took :
      real time : 0.015
      cpu time  : 0.000


31
32        proc transpose data=workx.STATSMEAN(keep=span30 tmax_n tmax_lclm2 tmax_mean tmax_uclm2) out=workx.xpo;
33        by span30;
34        var tmax_lclm2 tmax_mean Tmax_uclm2 ;
35        run;quit;
NOTE: 5 observations were read from "WORKX.STATSMEAN"
NOTE: Data set "WORKX.xpo" has 15 observation(s) and 3 variable(s)
NOTE: Procedure transpose step took :
      real time : 0.000
      cpu time  : 0.015


36
37        proc format ;
38          value span2yrs
39            1 = "1875_1904"
40            2 = "1905_1934"
41            3 = "1935_1964"
42            4 = "1965_1994"
43            5 = "1995_2024"
44        ;run;
NOTE: Format span2yrs output
NOTE: Procedure format step took :
      real time : 0.000
      cpu time  : 0.000


45
46        data workx.xpofix;
47          set xpo;
                ^
ERROR: Data set "WORK.xpo" not found
48          ano=put(col1,4.1);
49        run;

NOTE: DATA step was not executed because of errors detected
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


50
51        options ls=100 ps=80;
52        proc plot data= workx.xpofix;
53          format span30 span2yrs.;
54          plot col1 * span30='-' $ ano / box ;
55        run;quit;
NOTE: Procedure plot step took :
      real time : 0.031
      cpu time  : 0.015


56
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.213
      cpu time  : 0.203
/*  _                        _              _           _
| || |    _____   _____ _ __| | __ _ _   _ | |__ (_)___| |_ ___   __ _ _ __ __ _ _ __ ___  ___
| || |_  / _ \ \ / / _ \ `__| |/ _` | | | || `_ \| / __| __/ _ \ / _` | `__/ _` | `_ ` _ \/ __|
|__   _|| (_) \ V /  __/ |  | | (_| | |_| || | | | \__ \ || (_) | (_| | | | (_| | | | | | \__ \
   |_|   \___/ \_/ \___|_|  |_|\__,_|\__, ||_| |_|_|___/\__\___/ \__, |_|  \__,_|_| |_| |_|___/
                                     |___/                       |___/
*/

data workx.thirty;
  retain span30 1;
  set workx.centralpark(where=(1874< year(datesas) < 2025));
  if mod(_n_,10957)=0 then span30=span30+1;
  if span30<6;
  period=put(span30,span_to_yrs.);
run;

libname works "d:/wpswrkx";
data workx.mrg15;
 merge workx.thirty(where=(span30=1) rename=tmax=YR_1875_1904)
       workx.thirty(where=(span30=5) rename=tmax=YR_1995_2024);
 drop datesas;
run;quit;

%utlfkil(d:/png/temperaturebalance.png);

 * First create the hist_data using proc univariate;
proc univariate data=workx.mrg15 noprint;
    histogram
        YR_1995_2024
        YR_1875_1904
        /
        midpoints=(0 to 110 by 5)
        outhistogram=workx.hist_data(rename=(_midpt_=midpoint));
run;

ods html(id=add_dest) gpath="d:\png";
ods graphics on /reset=all imagename="temperaturebalance";
proc sgplot data=workx.hist_data;
title "Frequency of Daily Max Air Temperature";
title2 "by 30 Year Periods 1875-1904 & 1995-2024";
title3 "Central Park NYC NY ";
    vbar midpoint / response=_count_ group=_var_
      transparency=0.3 barwidth=0.8
      stat=percent
      groupdisplay=cluster;  * This overlays/clusters bars side by side;
    xaxis values=(0 to 110 by 5) label="Temperature";
    yaxis label="Percent";
inset (
  "Blue"    = "1875-1904 More Cooler Temps"
  "Green"   = "1995-2024 More Hotter Temps") /
      position=TopLeft border;
run;
ods graphics off;
ods _all_ close;
ods listing;


%utlfkil(d:/png/temperaturebalance.png);

ods html(id=add_dest) gpath="d:\png";
ods graphics on /reset=all imagename="balance.png";
title "Frequency of Daily Max Air Temperatures";
title2 "by 30 Year Periods 1875-1904 & 1995-2024";
title3 "Central Park NYC NY ";
proc sgplot data=workx.mrg15;
label YR_1875_1904 = "1875-1904 & 1995-2024";
histogram YR_1875_1904;
histogram YR_1995_2024 / transparency=.5;
inset (
  "Blue"    = "1875-1904 More Cooler Temps"
  "Tan"     = "1995-2024 More Hotter Temps"
  "Purple"  = "Shared Frequency") /
      position=TopLeft border;
run;
ods graphics off;
ods _all_ close;

/*     _     _                                    _
| |__ (_)___| |_ ___   __ _ _ __ __ _ _ __ ___   | | ___   __ _
| `_ \| / __| __/ _ \ / _` | `__/ _` | `_ ` _ \  | |/ _ \ / _` |
| | | | \__ \ || (_) | (_| | | | (_| | | | | | | | | (_) | (_| |
|_| |_|_|___/\__\___/ \__, |_|  \__,_|_| |_| |_| |_|\___/ \__, |
                      |___/                               |___/
*/

1                                          Altair SLC       13:54 Wednesday, April 22, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp

NOTE: Library worksas assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\worksas

NOTE: Library workwpd assigned as follows:
      Engine:        WPD
      Physical Name: d:\workwpd


LOG:  13:54:42
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.017
      cpu time  : 0.000


NOTE: Format num2mis output
NOTE: Format $chr2mis output
NOTE: Procedure format step took :
      real time : 0.010
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1
2         data workx.thirty;
3           retain span30 1;
4           set workx.centralpark(where=(1874< year(datesas) < 2025));
5           if mod(_n_,10957)=0 then span30=span30+1;
6           if span30<6;
NOTE: Format span_to_yrs was not found or could not be loaded
7           period=put(span30,span_to_yrs.);
8         run;

NOTE: 54787 observations were read from "WORKX.centralpark"
NOTE: Data set "WORKX.thirty" has 54784 observation(s) and 5 variable(s)
NOTE: The data step took :
      real time : 0.068
      cpu time  : 0.062


NOTE: Directory contains files of mixed engine types
9
10        libname works "d:/wpswrkx";
NOTE: Library works assigned as follows:
      Engine:        WPD
      Physical Name: d:\wpswrkx

11        data workx.mrg15;
12         merge workx.thirty(where=(span30=1) rename=tmax=YR_1875_1904)
13               workx.thirty(where=(span30=5) rename=tmax=YR_1995_2024);
14         drop datesas;
15        run;

NOTE: 10956 observations were read from "WORKX.thirty"
NOTE: 10957 observations were read from "WORKX.thirty"
NOTE: Data set "WORKX.mrg15" has 10957 observation(s) and 5 variable(s)
NOTE: The data step took :
      real time : 0.029
      cpu time  : 0.031


15      !     quit;
16
17        %utlfkil(d:/png/temperaturebalance.png);
18
19         * First create the hist_data using proc univariate;
20        proc univariate data=workx.mrg15 noprint;
21            histogram
22                YR_1995_2024
23                YR_1875_1904
24                /
25                midpoints=(0 to 110 by 5)
26                outhistogram=workx.hist_data(rename=(_midpt_=midpoint));
27        run;
NOTE: Successfully written image .\Histogram.png
NOTE: Successfully written image .\Histogram1.png
NOTE: 10957 observation(s) were read from "WORKX.mrg15"
NOTE: Data set "WORKX.hist_data" has 46 observation(s) and 4 variable(s)
NOTE: Procedure univariate step took :
      real time : 0.169
      cpu time  : 0.109


WARNING: Unresolved file reference, setting default filename to ./wpsods1.html.
NOTE: Writing HTML(add_dest) BODY file C:\slc\wpsods1.html
28
29        ods html(id=add_dest) gpath="d:\png";
30        ods graphics on /reset=all imagename="temperaturebalance";
31        proc sgplot data=workx.hist_data;
32        title "Frequency of Daily Max Air Temperature";
33        title2 "by 30 Year Periods 1875-1904 & 1995-2024";
34        title3 "Central Park NYC NY ";
35            vbar midpoint / response=_count_ group=_var_
36              transparency=0.3 barwidth=0.8
37              stat=percent
38              groupdisplay=cluster;  * This overlays/clusters bars side by side;
39            xaxis values=(0 to 110 by 5) label="Temperature";
40            yaxis label="Percent";
41        inset (
42          "Blue"    = "1875-1904 More Cooler Temps"
43          "Green"   = "1995-2024 More Hotter Temps") /
44              position=TopLeft border;
45        run;
NOTE: Successfully written image d:\png\temperaturebalance.png
NOTE: Successfully written image temperaturebalance1.png
NOTE: Procedure sgplot step took :
      real time : 0.071
      cpu time  : 0.062


46        ods graphics off;
47        ods _all_ close;
48        ods listing;
49
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.490
      cpu time  : 0.375

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
