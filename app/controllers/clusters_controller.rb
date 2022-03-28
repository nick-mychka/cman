class ClustersController < ApplicationController
  before_action :authorized

  def index
    clusters = current_user.clusters
    render json: ClusterBlueprint.render(clusters)
  end

  def create
    cluster = current_user.clusters.new(cluster_params)
    cluster.save!
    render json: ClusterBlueprint.render(cluster), status: :created
  rescue
    render json: cluster, status: :unprocessable_entity
  end

  def update
    current_cluster.update!(update_cluster_params)
    render json: ClusterBlueprint.render(current_cluster), status: :ok
  rescue
    render json: current_cluster, status: :unprocessable_entity
  end

  def destroy
    current_cluster.destroy
    head :no_content
  end

private
  def cluster_params
    params.permit(:name)
  end

  def update_cluster_params
    params.permit(:name)
  end

  def current_cluster
    @_current_cluster ||= current_user.clusters.find(params[:id])
  end
end
