require 'rufus-scheduler'

class AuthedBulkWorker < OneirrosWorker
  def initialize(spider_class, every)
    @spider = spider_class.new
    @sched = Rufus::Scheduler.singleton

    @sched.every every do
      @spider.go
    end
  end

  def join 
    @sched.join
  end
end
