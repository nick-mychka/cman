class ClustersController < ApplicationController
  before_action :authorized

  def index
    clusters = current_user.clusters.sorted_by_view_order
    render json: ClusterBlueprint.render(clusters)
  end

  def update_clusters_order
    grouped_clusters = update_clusters_order_params[:clusters].each_with_object({}) do |cluster, memo|
      memo[cluster[:id]] = { view_order: cluster[:view_order] }
    end

    current_user.clusters.update(grouped_clusters.keys, grouped_clusters.values)

    clusters = current_user.clusters.sorted_by_view_order
    render json: ClusterBlueprint.render(clusters)
  rescue
    render json: clusters, status: :unprocessable_entity
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
    params.permit(:name, :view_order)
  end

  def update_cluster_params
    params.permit(:name)
  end

  def update_clusters_order_params
    params.permit(clusters: %i[id view_order])
  end

  def current_cluster
    @_current_cluster ||= current_user.clusters.find(params[:id])
  end
end
