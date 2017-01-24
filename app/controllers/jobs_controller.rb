class JobsController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :edit, :destroy, :update]
  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:alert] = "This Job already archieved"
      redirect_to root_path
    end
  end

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.order('wage_lower_bound DESC')
    when 'by_upper_bound'
      Job.published.order('wage_upper_bound DESC')
    else
      Job.published.recent
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      flash[:notice] = "created success"
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
       redirect_to jobs_path
       flash[:notice] = "Updated"
    else
       render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end
  def category
    @jobs = case params[:order]
    when 'by_architecture'
      Job.published.where(:category => "architecture")
    when 'by_arts'
      Job.published.where(:category => "arts")
    when 'by_business'
      Job.published.where(:category => "business")
    when 'by_community_service'
      Job.published.where(:category => "community service")
    when 'by_education'
      Job.published.where(:category => "education")
    when 'by_healthcare_support'
      Job.published.where(:category => "healthcare suooprt")
    when 'by_food_service'
      Job.published.where(:category => "food service")
    when 'by_developer'
      Job.published.where(:category => "developer")
    end
  end



  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :category, :city)
  end
end
