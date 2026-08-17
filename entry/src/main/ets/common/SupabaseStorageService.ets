import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { http } from '@kit.NetworkKit';
import { isNetworkAvailable } from './NetworkHelper';
import { SupabaseConfig } from './SupabaseConfig';

export async function pickImageUri(): Promise<string | undefined> {
  const options = new photoAccessHelper.PhotoSelectOptions();
  options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
  options.maxSelectNumber = 1;
  const picker = new photoAccessHelper.PhotoViewPicker();
  try {
    const result = await picker.select(options);
    if (result.photoUris.length > 0) {
      return result.photoUris[0];
    }
    return undefined;
  } catch (err) {
    const error = err as BusinessError;
    console.error(`pickImageUri failed, code=${error.code}, message=${error.message}`);
    return undefined;
  }
}

function _readFileBuffer(uri: string): ArrayBuffer | undefined {
  let file: fileIo.File | undefined = undefined;
  try {
    file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
    const stat = fileIo.statSync(file.fd);
    const buffer = new ArrayBuffer(stat.size);
    fileIo.readSync(file.fd, buffer);
    return buffer;
  } catch (err) {
    const error = err as BusinessError;
    console.error(`readFileBuffer failed, code=${error.code}, message=${error.message}`);
    return undefined;
  } finally {
    if (file) {
      fileIo.closeSync(file);
    }
  }
}

function _resolveContentType(uri: string): string {
  const lowerUri = uri.toLowerCase();
  if (lowerUri.endsWith('.png')) {
    return 'image/png';
  }
  if (lowerUri.endsWith('.webp')) {
    return 'image/webp';
  }
  if (lowerUri.endsWith('.gif')) {
    return 'image/gif';
  }
  return 'image/jpeg';
}

function _resolveExtension(contentType: string): string {
  if (contentType === 'image/png') {
    return 'png';
  }
  if (contentType === 'image/webp') {
    return 'webp';
  }
  if (contentType === 'image/gif') {
    return 'gif';
  }
  return 'jpg';
}

function _buildObjectPath(contentType: string): string {
  return `demo/${Date.now()}.${_resolveExtension(contentType)}`;
}

export async function uploadImageToSupabase(uri: string): Promise<string | undefined> {
  if (!isNetworkAvailable()) {
    console.error('uploadImageToSupabase failed: network unavailable');
    return undefined;
  }

  const contentType = _resolveContentType(uri);
  const objectPath = _buildObjectPath(contentType);
  const fileBuffer = _readFileBuffer(uri);
  if (!fileBuffer) {
    return undefined;
  }

  const uploadUrl =
    `${SupabaseConfig.PROJECT_URL}/storage/v1/object/${SupabaseConfig.STORAGE_BUCKET}/${objectPath}`;
  const publicUrl =
    `${SupabaseConfig.PROJECT_URL}/storage/v1/object/public/${SupabaseConfig.STORAGE_BUCKET}/${objectPath}`;

  const httpRequest = http.createHttp();
  try {
    const response = await httpRequest.request(uploadUrl, {
      method: http.RequestMethod.POST,
      header: {
        'Authorization': `Bearer ${SupabaseConfig.ANON_KEY}`,
        'apikey': SupabaseConfig.ANON_KEY,
        'Content-Type': contentType,
        'x-upsert': 'true',
      },
      extraData: fileBuffer,
      connectTimeout: 60000,
      readTimeout: 60000,
    });
    if (response.responseCode !== 200) {
      console.error(`uploadImageToSupabase failed, code=${response.responseCode}, body=${response.result}`);
      return undefined;
    }
    return publicUrl;
  } catch (err) {
    const error = err as BusinessError;
    console.error(`uploadImageToSupabase failed, code=${error.code}, message=${error.message}`);
    return undefined;
  } finally {
    httpRequest.destroy();
  }
}
