﻿# Get last first day of previous month in yyyy-mm-dd format. For example, this command run on April 4, 2016, would return 2016-03-01
((Get-Date -Day 1 -hour 0 -minute 0 -second 0).AddMonths(-1)).Date.ToString("yyyy-MM-dd")