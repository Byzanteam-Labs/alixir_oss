defmodule Alixir.OSS do
  @moduledoc """
  `Alixir.OSS` enables puting and deleting objects for Aliyun
  OSS.

  ## Examples

    ```
    Alixir.OSS.put_object(args...)
    |> Alixir.request()

    Alixir.OSS.delete_objects(args...)
    |> Alixir.request()
    ```

  See `put_object/4` and `delete_object/4` for more details.
  """

  alias Alixir.OSS.FileObject
  alias Alixir.OSS.Operation
  alias Alixir.OSS.PresignedURL
  alias Alixir.OSS.PostObjectData

  @doc """
  Put object to OSS. Return an `Alixir.OSS.Operation` struct which
  could be passed to `Alixir.request` to perform the
  request.

  ## Example

    iex> file_object = %Alixir.OSS.FileObject{bucket: "foo_bucket", object_key: "foo/bar.jpg", object: File.stream!("test/data/bar.jpg")}
    ...> operation = Alixir.OSS.put_object(file_object, "X-OSS-Object-Acl": "public-read")
    ...> with %Alixir.OSS.Operation{http_method: :put, bucket: "foo_bucket", object_key: "foo/bar.jpg",
    ...>   file: %File.Stream{path: "test/data/bar.jpg"}, oss_headers: oss_headers} when is_list(oss_headers) <- operation, do: true
    true
  """
  @spec put_object(
          %FileObject{},
          list()
        ) :: %Alixir.OSS.Operation{http_method: :put}
  def put_object(
        %FileObject{bucket: bucket, object_key: object_key, object: object},
        oss_headers \\ []
      )
      when is_list(oss_headers) do
    %Operation{
      http_method: :put,
      bucket: bucket,
      object_key: object_key,
      file: object,
      oss_headers: oss_headers
    }
  end

  @doc """
  Delete object from OSS. Return an `Alixir.OSS.Operation` struct which
  could be passed to `Alixir.request` to perform the
  request.

  ## Example

    iex> file_object = %Alixir.OSS.FileObject{bucket: "foo_bucket", object_key: "foo/bar.jpg"}
    ...> operation = Alixir.OSS.delete_object(file_object)
    ...> with %Alixir.OSS.Operation{http_method: :delete, bucket: "foo_bucket", object_key: "foo/bar.jpg",
    ...>   oss_headers: oss_headers} when is_list(oss_headers) <- operation, do: true
    true
  """
  @spec delete_object(
          %FileObject{},
          list()
        ) :: %Alixir.OSS.Operation{http_method: :delete}
  def delete_object(%FileObject{bucket: bucket, object_key: object_key}, oss_headers \\ [])
      when is_list(oss_headers) do
    %Operation{
      http_method: :delete,
      bucket: bucket,
      object_key: object_key,
      oss_headers: oss_headers
    }
  end

  @doc """
  Generate a presigned URL, which could be used by other other applications (such as
  frontend) to operate OSS
  """
  @spec presigned_url(
          atom(),
          %FileObject{},
          Keyword.t()
        ) :: String.t()
  defdelegate presigned_url(http_method, file_object, options \\ []), to: PresignedURL

  @doc """
  Generate a presigned URL, which could be used by other other applications (such as
  frontend) to operate OSS
  """
  @spec post_object_data(
          %FileObject{},
          Keyword.t()
        ) :: map()
  defdelegate post_object_data(file_object, policy_options \\ []), to: PostObjectData

  @doc """
  Head an object. Return true if the object exists, or false if it doesn't exist.
  """
  @spec head_object(
          String.t(),
          String.t()
        ) :: boolean()
  def head_object(bucket, key) do
    %Operation{
      http_method: :head,
      bucket: bucket,
      object_key: key,
      oss_headers: []
    }
  end
end
