require 'gruff'

current_car_events = [
  {
    name: "oil changes",
    frequency: 5 * 30,
    cost: 45,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: "gas",
    frequency: 6,
    cost: 40,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: "insurance",
    frequency: 30,
    cost: 175,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: 'new tires',
    frequency: 2*365,
    cost: 600,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: 'major repairs',
    frequency: 2*365,
    cost: 2500,
    starts_after: 0,
    stops_after: 9999999
  },
  {
     name: 'minor repairs',
    frequency: 6*30,
    cost: 300,
    starts_after: 0,
    stops_after: 9999999
  }
];

tesla_car_events = [
  {
    name: "replace battery",
    frequency: 10*365,
    cost: 6000,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: "electricity",
    frequency: 6,
    cost: 20,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: "insurance",
    frequency: 30,
    cost: 175,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: "loan",
    frequency: 30,
    cost: 500,
    starts_after: 0,
    stops_after: 5*365
  },
  {
    name: 'new tires',
    frequency: 2*365,
    cost: 800,
    starts_after: 0,
    stops_after: 9999999
  },
  {
    name: 'major repairs',
    frequency: 2*365,
    cost: 1500,
    starts_after: 5*365,
    stops_after: 9999999
  },
  {
     name: 'minor repairs',
    frequency: 6*30,
    cost: 100,
    starts_after: 5*365,
    stops_after: 9999999
  }
];

COMMON_YEAR_DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

def run_simulation(events, max_years)
  counters = []
  for e in events
    counters.push(e[:frequency])
  end

  current_car_cost = 0
  current_days = 0
  data = []

  for y in 0..(max_years-1)
    for m in 0..11
      for d in 0..(COMMON_YEAR_DAYS_IN_MONTH[m] - 1)
        counters.each_with_index do |remaining_days, index|
          e = events[index]
          if current_days > e[:starts_after] && current_days < e[:stops_after]
            counters[index] = remaining_days - 1
            if counters[index] <= 0
              #puts "Paying for #{e[:name]}" if e[:cost] > 200
              counters[index] = e[:frequency] - counters[index]
              current_car_cost += e[:cost]
            end
          end
        end
        data.push(current_car_cost)
        current_days = current_days + 1
      end
    end
    if current_car_cost>0
      puts "End of year #{y+1}: $#{current_car_cost}"
    end
  end
  return data
end

max_years=21
g = Gruff::Line.new

glabels = {}
for y in 1..(max_years)
  glabels[y*365 - 364/2] = "#{y}y" if y%2 == 0
end
g.labels = glabels

g.data 'Current Car', run_simulation(current_car_events, max_years)
g.data 'Tesla Model 3', run_simulation(tesla_car_events, max_years)
g.write('costs.png')
