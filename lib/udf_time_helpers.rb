class UdfTimeHelpers
  UDFS = [
      {
          type:        :function,
          name:        :now,
          description: "Returns the current time as a timestamp in UTC",
          params:      nil,
          return_type: "timestamp",
          body:        %~
            from datetime import datetime
            datetime.utcnow()
          ~,
          tests:       [
                           {query: "select ?()", expect: '2015-03-30 21:32:15.553489+00', example: true, skip: true},
                       ]
      }, {
          type:        :function,
          name:        :posix_timestamp,
          description: "Returns the number of seconds from 1970-01-01 for this timestamp",
          params:      "ts timestamp",
          return_type: "real",
          body:        %~
            from datetime import datetime
            if not ts:
              return None
            return (ts - datetime(1970, 1, 1)).total_seconds()
          ~,
          tests:       [
                           {query: "select ?('2015-03-30 21:32:15'::timestamp)", expect: '1427751521.107629', example: true, skip: true},
                       ]
      },
      {
          type:        :function,
          name:        :is_last_day_of_month,
          description: "Detects if a given date is on the last day of the month",
          params:      "ts timestamp",
          return_type: "boolean",
          body:        %~
            from datetime import datetime
            import calendar
            if ts is None:
                return False
            return calendar.monthrange(ts.year,ts.month)[1] == ts.day
          ~,
          tests:       [
                           {query: "select ?('2015-10-01')", expect: 'f', example: true},
                           {query: "select ?('2015-10-31')", expect: 't', example: true}
                       ]
      },
      {
          type:        :function,
          name:        :days_left_in_month,
          description: "For a given date, calculates how many days are left in the month",
          params:      "ts timestamp",
          return_type: "int",
          body:        %~
            from datetime import datetime
            import calendar
            if ts is None:
                return None
            return calendar.monthrange(ts.year,ts.month)[1] - ts.day
          ~,
          tests:       [
                           {query: "select ?('2015-11-01')", expect: 29, example: true},
                           {query: "select ?('2015-12-28')", expect: 3, example: true},
                           {query: "select ?(NULL)", expect: nil, example: true}
                       ]
      }
  ]
end
